import core

/**
PID Controller to adjust a gauge based on a periodic error correction.

For more context, see https://en.wikipedia.org/wiki/PID_controller
*/
class Controller:
  kp/float
  ki/float
  kd/float

  min/float
  max/float

  constructor --.kp=0.0 --.ki=0.0 --.kd=0.0 --.min=0.0 --.max=1.0:

  last_error_/float := 0.0
  integral_error_/float := 0.0

  /**
   Update the controller with a new error and elapsed time since
    the last update.

  Returns the new gauge value after the error correction.
  */
  update error/float elapsed/Duration -> float:
    elapsed_s := elapsed.in_s.to_float / Duration.NANOSECONDS_PER_SECOND
    integral_error_ += error * elapsed_s
    derivative_error := (error - last_error_) / elapsed_s
    output := kp * error + ki * integral_error_ + kd * derivative_error
    last_error_ = error
    return core.max
      min
      core.min max output
