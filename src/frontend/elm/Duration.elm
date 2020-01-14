module Duration exposing (Duration, inMilliseconds, inNanoseconds, milliseconds, nanoseconds)

-- TYPES


type Duration
    = Duration Float



-- CONVERSIONS


nanoseconds : Float -> Duration
nanoseconds =
    Duration


inNanoseconds : Duration -> Float
inNanoseconds (Duration ns) =
    ns


milliseconds : Float -> Duration
milliseconds ms =
    Duration (ms * 1000000)


inMilliseconds : Duration -> Float
inMilliseconds (Duration ns) =
    ns / 1000000
