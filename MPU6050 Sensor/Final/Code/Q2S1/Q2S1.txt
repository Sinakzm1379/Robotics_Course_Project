#include "I2Cdev.h"
#include "MPU6050_6Axis_MotionApps20.h"
#include <Kalman.h>
#if I2CDEV_IMPLEMENTATION == I2CDEV_ARDUINO_WIRE
  #include "Wire.h"
#endif

MPU6050 mpu;

// quaternion components in a [w, x, y, z] format
#define OUTPUT_READABLE_QUATERNION

// yaw/pitch/roll angles (in degrees) calculated from the quaternions coming from the FIFO
#define OUTPUT_READABLE_YAWPITCHROLL
bool dmpReady = false;
uint8_t devStatus;
uint8_t fifoBuffer[64];
Quaternion q;         // [w, x, y, z]         quaternion container
VectorInt16 gy;       // [x, y, z]            gyro sensor measurements
VectorInt16 aa;       // [x, y, z]            accel sensor measurements
VectorInt16 aaReal;   // [x, y, z]            gravity-free accel sensor measurements
VectorInt16 aaWorld;  // [x, y, z]            world-frame accel sensor measurements
VectorFloat gravity;  // [x, y, z]            gravity vector
float euler[3];       // [psi, theta, phi]    Euler angle container
float ypr[3];         // [yaw, pitch, roll]   yaw/pitch/roll container and gravity vector        // [yaw, pitch, roll]   yaw/pitch/roll container and gravity vector


#define RESTRICT_Roll_PITCH_YAW  // Comment out to restrict roll to ±90deg instead
Kalman kalmanX;                  // Create the Kalman instances
Kalman kalmanY;
Kalman kalmanZ;

/* IMU Data */
double accX, accY, accZ;
double gyroX, gyroY, gyroZ;
double gyroXangle, gyroYangle, gyroZangle;  // Angle calculate using the gyro only
double compAngleX, compAngleY, compAngleZ;  // Calculated angle using a complementary filter
double kalAngleX, kalAngleY, kalAngleZ;     // Calculated angle using a Kalman filter
uint32_t timer;
uint8_t i2cData[14];  // Buffer for I2C data

void setup() {

#if I2CDEV_IMPLEMENTATION == I2CDEV_ARDUINO_WIRE
  Wire.begin();
  Wire.setClock(400000);
#elif I2CDEV_IMPLEMENTATION == I2CDEV_BUILTIN_FASTWIRE
  Fastwire::setup(400, true);
#endif

  Serial.begin(115200);
  while (!Serial)
    ;

  Serial.println(F("Initializing I2C devices..."));
  mpu.initialize();

  Serial.println(F("Testing device connections..."));
  Serial.println(mpu.testConnection() ? F("MPU6050 connection successful") : F("MPU6050 connection failed"));

  Serial.println(F("Initializing DMP..."));
  devStatus = mpu.dmpInitialize();

  mpu.setXGyroOffset(220);
  mpu.setYGyroOffset(76);
  mpu.setZGyroOffset(-85);
  mpu.setZAccelOffset(1788);

  if (devStatus == 0) {
    mpu.CalibrateAccel(6);
    mpu.CalibrateGyro(6);
    mpu.PrintActiveOffsets();
    Serial.println(F("Enabling DMP..."));
    mpu.setDMPEnabled(true);

    dmpReady = true;
  } else {
    Serial.print(F("DMP Initialization failed (code "));
    Serial.print(devStatus);
    Serial.println(F(")"));
  }


  delay(100);  // Wait for sensor to stabilize

  // It is then converted from radians to degrees
  mpu.dmpGetQuaternion(&q, fifoBuffer);
  mpu.dmpGetGravity(&gravity, &q);
  mpu.dmpGetYawPitchRoll(ypr, &q, &gravity);
  float roll = ypr[2] * 180 / M_PI;
  float pitch = ypr[1] * 180 / M_PI;
  float yaw = ypr[0] * 180 / M_PI;

  kalmanX.setAngle(roll);  // Set starting angle
  kalmanY.setAngle(pitch);
  kalmanZ.setAngle(yaw);
  gyroXangle = roll;
  gyroYangle = pitch;
  gyroZangle = yaw;
  compAngleX = roll;
  compAngleY = pitch;
  compAngleZ = yaw;

  timer = micros();
}


void loop() {

  if (!dmpReady) return;
  // read a packet from FIFO
  if (mpu.dmpGetCurrentFIFOPacket(fifoBuffer)) {
    // display initial world-frame acceleration, adjusted to remove gravity
    mpu.dmpGetQuaternion(&q, fifoBuffer);
    mpu.dmpGetGravity(&gravity, &q);
    mpu.dmpGetYawPitchRoll(ypr, &q, &gravity);
    float roll = ypr[2] * 180 / M_PI;
    float pitch = ypr[1] * 180 / M_PI;
    float yaw = ypr[0] * 180 / M_PI;
    gyroX = roll;
    gyroY = pitch;
    gyroZ = yaw;
    double dt = (double)(micros() - timer) / 1000000;  // Calculate delta time
    timer = micros();
    mpu.dmpGetGyro(&gy, fifoBuffer);
    double gyroXrate = gy.x / 131.0;  // Convert to deg/s
    double gyroYrate = gy.y / 131.0;  // Convert to deg/s
    double gyroZrate = gy.z / 131.0;  // Convert to deg/s

    // This fixes the transition problem when the accelerometer angle jumps between -180 and 180 degrees
    if ((roll < -90 && kalAngleX > 90) || (roll > 90 && kalAngleX < -90)) {
      kalmanX.setAngle(roll);
      compAngleX = roll;
      kalAngleX = roll;
      gyroXangle = roll;
    } else
      kalAngleX = kalmanX.getAngle(roll, gyroXrate, dt);  // Calculate the angle using a Kalman filter

    // This fixes the transition problem when the accelerometer angle jumps between -180 and 180 degrees
    if ((pitch < -90 && kalAngleY > 90) || (pitch > 90 && kalAngleY < -90)) {
      kalmanY.setAngle(pitch);
      compAngleY = pitch;
      kalAngleY = pitch;
      gyroYangle = pitch;
    } else
      kalAngleY = kalmanY.getAngle(pitch, gyroYrate, dt);  // Calculate the angle using a Kalman filter

    // This fixes the transition problem when the accelerometer angle jumps between -180 and 180 degrees
    if ((yaw < -90 && kalAngleZ > 90) || (yaw > 90 && kalAngleZ < -90)) {
      kalmanY.setAngle(yaw);
      compAngleZ = yaw;
      kalAngleZ = yaw;
      gyroZangle = yaw;
    } else
      kalAngleZ = kalmanZ.getAngle(yaw, gyroZrate, dt);  // Calculate the angle using a Kalman filter

    gyroXangle += gyroXrate * dt;  // Calculate gyro angle without any filter
    gyroYangle += gyroYrate * dt;
    gyroZangle += gyroZrate * dt;
    //gyroXangle += kalmanX.getRate() * dt; // Calculate gyro angle using the unbiased rate
    //gyroYangle += kalmanY.getRate() * dt;

    float alpha = 0.98;
    compAngleX = alpha * (compAngleX + gyroXrate * dt) + (1 - alpha) * roll;  // Calculate the angle using a Complimentary filter
    compAngleY = alpha * (compAngleY + gyroYrate * dt) + (1 - alpha) * pitch;
    compAngleZ = alpha * (compAngleZ + gyroZrate * dt) + (1 - alpha) * yaw;

    // Reset the gyro angle when it has drifted too much
    if (gyroXangle < -180 || gyroXangle > 180)
      gyroXangle = kalAngleX;
    if (gyroYangle < -180 || gyroYangle > 180)
      gyroYangle = kalAngleY;
    if (gyroZangle < -180 || gyroZangle > 180)
      gyroZangle = kalAngleZ;

    /* Print Data */

    Serial.print(roll);
    Serial.print("\t");
    Serial.print(compAngleX);
    Serial.print("\t");
    Serial.print(kalAngleX);
    Serial.print("\t");

    Serial.print("\t");

    Serial.print(pitch);
    Serial.print("\t");
    Serial.print(compAngleY);
    Serial.print("\t");
    Serial.print(kalAngleY);
    Serial.print("\t");

    Serial.print("\t");

    Serial.print(yaw);
    Serial.print("\t");
    Serial.print(compAngleZ);
    Serial.print("\t");
    Serial.print(kalAngleZ);
    Serial.print("\t");

    Serial.print("\r\n");
    delay(2);
  }
}