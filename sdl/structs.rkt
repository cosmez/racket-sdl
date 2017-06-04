#lang racket
(require  
  ffi/unsafe
  ffi/unsafe/define
  ffi/cvector
  ffi/unsafe/cvector)

(provide (all-defined-out))

(require "constants.rkt")

(define-cstruct _SDL_version
  ((major _sint8)
   (minor _sint8)
   (patch _uint8)))

; SDL_pixels.h
(define-cstruct _SDL_Color
  ((r _uint8)
   (g _uint8)
   (b _uint8)))

(define-cstruct _SDL_Palette
  ((ncolors _int)
   (colors _SDL_Color-pointer)
   (version _uint32)
   (refcount _int)))

(define-cstruct _SDL_PixelFormat
  ([format _uint32]
   [palette _SDL_Palette-pointer]
   [BitsPerPixel _uint8]
   [BytesPerPixel _uint8]
   [padding (make-array-type _uint8 2)]
   [Rmask _uint32]
   [Gmask _uint32]
   [Bmask _uint32]
   [Amask _uint32]
   [Rloss _uint8]
   [Gloss _uint8]
   [Bloss _uint8]
   [Aloss _uint8]
   [Rshift _uint8]
   [Gshift _uint8]
   [Bshift _uint8]
   [Ashift _uint8]
   [refcount _int]
   [next _SDL_PixelFormat-pointer]))

; SDL_Rect.h
(define-cstruct _SDL_Point
  ([x _int]
   [y _int]))

(define-cstruct _SDL_Rect
  ([x _int]
   [y _int]
   [w _int]
   [h _int]))

;SDL_Surface.h
(define-cstruct _SDL_Surface
  ([flags _uint32]
   [format _SDL_PixelFormat-pointer]
   [w _int]
   [h _int]
   [pitch _int]
   [pixels _pointer]
   [userdata _pointer]
   [locked _int]
   [lock_data _pointer]
   [clip_rect _SDL_Rect]
   [map _pointer]
   [refcount _int]))

;SDL_video.h 
(define-cstruct _SDL_DisplayMode
  ((format _uint32)
   (w _int)
   (h _int)
   (refresh_rate _int)
   (driverdata _pointer)))


(define _SDL_Window _pointer)
(define _SDL_GLContext _pointer)

;SDL_audio.h

(define _SDL_AudioFormat _uint16)
(define _SDL_AudioCallback (_fun _pointer (_ptr io _uint8) _int -> _void))
(define AUDIO_S16LSB #x8010)
(define AUDIO_S16MSB #x9010)
(define AUDIO_S16 AUDIO_S16LSB)
(define AUDIO_S16SYS
  (if (= SDL_BYTEORDER SDL_LIL_ENDIAN)
      AUDIO_S16LSB
      AUDIO_S16MSB))
(define SDL_AudioFilter _pointer)
(define SDL_AudioDeviceID _uint32)

(define-cstruct _SDL_AudioSpec
  ([freq _int]
   [format _SDL_AudioFormat]
   [channels _uint8]
   [silence _uint8]
   [samples _uint16]
   [size _uint32]
   [callback _SDL_AudioCallback]
   [userdata _pointer]))

(define-cstruct _SDL_AudioCVT
  ([needed _int]
   [src_format _SDL_AudioFormat]
   [dst_format _SDL_AudioFormat]
   [buf (_cpointer _uint8)]
   [len _int]
   [len_cvt _int]
   [len_mult _int]
   [len_ratio _double]
   [filters (make-array-type SDL_AudioFilter 10)]
   [filter_index _int]))

; SDL_keyboard.h

(define-cstruct _SDL_Keysym
  ([scancode SDL_Scancode]
   [sym SDL_Keycode]
   [mod _uint16]
   [unicode _uint32]))

; SDL_mouse.h

(define _SDL_Cursor _pointer)

; SDL_Joystic.h

(define _SDL_Joystick _pointer)
(define SDL_JoystickID _int32)

(define-cstruct _SDL_JoystickGUID
  ([data  (make-array-type _uint8 16)]))


; SDL_haptic.h

(define _SDL_Haptic _pointer)

(define-cstruct _SDL_HapticDirection
  ([type _uint8]
   [dir (make-array-type _int32 3)]))

(define-cstruct _SDL_HapticConstant
  ([type _uint16]
   [direction _SDL_HapticDirection]
   [length _uint32]
   [delay _uint16]
   [button _uint16]
   [interval _uint16]
   [level _int16]
   [attack_length _uint16]
   [attack_level _uint16]
   [fade_length _uint16]
   [fade_level _uint16]))

(define-cstruct _SDL_HapticPeriodic
  ([type _uint16]
   [direction _SDL_HapticDirection]
   [length _uint32]
   [delay _uint16]
   [button _uint16]
   [interval _uint16]
   [period _uint16]
   [magnitude _int16]
   [offset _int16]
   [phase _uint16]
   [attack_length _uint16]
   [attack_level _uint16]
   [fade_length _uint16]
   [fade_level _uint16]))

(define-cstruct _SDL_HapticCondition
  ([type _uint16]
   [direction _SDL_HapticDirection]
   [length _uint32]
   [delay _uint16]
   [button _uint16]
   [interval _uint16]
   [right_sat (make-array-type _uint16 3)]
   [left_sat (make-array-type _uint16 3)]
   [right_coeff (make-array-type _int16 3)]
   [left_coeff (make-array-type _int16 3)]
   [deadband (make-array-type _uint16 3)]
   [center (make-array-type _int16 3)]))


(define-cstruct _SDL_HapticRamp
  ([type _uint16]
   [direction _SDL_HapticDirection]
   [length _uint32]
   [delay _uint16]
   [button _uint16]
   [interval _uint16]
   [start _int16]
   [end _int16]
   [attack_length _uint16]
   [attack_level _uint16]
   [fade_length _uint16]
   [fade_level _uint16]))


(define-cstruct _SDL_HapticCustom
  ([type _uint16]
   [direction _SDL_HapticDirection]
   [length _uint32]
   [delay _uint16]
   [button _uint16]
   [interval _uint16]
   [channels _uint8]
   [period _uint16]
   [samples _uint16]
   [data _uint16*]
   [attack_length _uint16]
   [attack_level _uint16]
   [fade_length _uint16]
   [fade_level _uint16]))


(define _SDL_HapticEffect
  (_union 
   _uint16 
   _SDL_HapticConstant 
   _SDL_HapticPeriodic
   _SDL_HapticCondition
   _SDL_HapticRamp
   _SDL_HapticCustom))

; SDL_gamecontroller.h

(define _SDL_GameController _pointer)

(define-cstruct _hat
  ([hat _int]
   [hat_mask _int]))

(define-cstruct _SDL_GameControllerButtonBind
  ([bindType  _SDL_GameControllerBindType]
   [value 
    (make-union-type _int _int _hat)]))



; SDL_touch.h


(define SDL_TouchID _int64)
(define SDL_FingerID _int64)

(define-cstruct _SDL_Finger
  ([id SDL_FingerID]
   [x _float]
   [y _float]
   [pressure _float]))

; SDL_gesture.h

(define SDL_GestureID _int64)

; SDL_Event.h

(define-cstruct _SDL_CommonEvent
  ([type _uint32]
   [timestamp _uint32]))


(define-cstruct _SDL_WindowEvent
  ([type _uint32]
   [timestamp _uint32]
   [windowID _uint32]
   [event _uint8]
   [padding1 _uint8]
   [padding2 _uint8]
   [padding3 _uint8]
   [data1 _int32]
   [data2 _int32]))

(define-cstruct _SDL_KeyboardEvent
  ([type _uint32]
   [timestamp _uint32]
   [windowID _uint32]
   [state _uint8]
   [repeat _uint8]
   [padding2 _uint8]
   [padding3 _uint8]))

(define-cstruct _SDL_TextEditingEvent
  ([type _uint32]
   [timestamp _uint32]
   [windowID _uint32]
   [text _string]
   [start _int32]
   [length _int32]))

(define-cstruct _SDL_TextInputEvent
  ([type _uint32]
   [timestamp _uint32]
   [windowID _uint32]
   [text _string]))

(define-cstruct _SDL_MouseMotionEvent
  ([type _uint32]
   [timestamp _uint32]
   [windowID _uint32]
   [which _uint32]
   [state _uint32]
   [x _int32]
   [y _int32] 
   [xrel _int32] 
   [yrel _int32]))

(define-cstruct _SDL_MouseButtonEvent
  ([type _uint32]
   [timestamp _uint32]
   [windowID _uint32]
   [which _uint32]
   [button _uint8]
   [state _uint8]
   [padding1 _uint8]
   [padding2 _uint8]
   [x _int32]
   [y _int32]))

(define-cstruct _SDL_MouseWheelEvent
  ([type _uint32]
   [timestamp _uint32]
   [windowID _uint32]
   [which _uint32]
   [x _int32]
   [y _int32]))

(define-cstruct _SDL_JoyAxisEvent
  ([type _uint32]
   [timestamp _uint32]
   [which SDL_JoystickID]
   [axis _uint8]
   [padding1 _uint8]
   [padding2 _uint8]
   [padding3 _uint8]
   [value _int16]
   [padding4 _uint16]))

(define-cstruct _SDL_JoyBallEvent
  ([type _uint32]
   [timestamp _uint32]
   [which SDL_JoystickID]
   [ball _uint8]
   [padding1 _uint8]
   [padding2 _uint8]
   [padding3 _uint8]
   [xrel _int16]
   [yrel _int16]))


(define-cstruct _SDL_JoyHatEvent
  ([type _uint32]
   [timestamp _uint32]
   [which SDL_JoystickID]
   [hat _uint8]
   [value _uint8]
   [padding1 _uint8]
   [padding2 _uint8]))


(define-cstruct _SDL_JoyButtonEvent
  ([type _uint32]
   [timestamp _uint32]
   [which SDL_JoystickID]
   [button _uint8]
   [state _uint8]
   [padding1 _uint8]
   [padding2 _uint8]))

(define-cstruct _SDL_JoyDeviceEvent
  ([type _uint32]
   [timestamp _uint32]
   [which _int32]))

(define-cstruct _SDL_ControllerAxisEvent
  ([type _uint32]
   [timestamp _uint32]
   [which SDL_JoystickID]
   [axis _uint8]
   [padding1 _uint8]
   [padding2 _uint8]
   [padding3 _uint8]
   [value _int16]
   [padding4 _uint16]))

(define-cstruct _SDL_ControllerButtonEvent
  ([type _uint32]
   [timestamp _uint32]
   [which SDL_JoystickID]
   [button _uint8]
   [state _uint8]
   [padding1 _uint8]
   [padding2 _uint8]))

(define-cstruct _SDL_ControllerDeviceEvent
  ([type _uint32]
   [timestamp _uint32]
   [which _int32]))

(define-cstruct _SDL_TouchFingerEvent
  ([type _uint32]
   [timestamp _uint32]
   [touchId SDL_TouchID]
   [fingerId SDL_FingerID]
   [x _float]
   [y _float]
   [dx _float]
   [dy _float]
   [pressure _float]))

(define-cstruct _SDL_MultiGestureEvent
  ([type _uint32]
   [timestamp _uint32]
   [touchId SDL_TouchID]
   [dTheta _float]
   [dDist _float]
   [x _float]
   [y _float]
   [numFingers _uint16]
   [padding _uint16]))

(define-cstruct _SDL_DollarGestureEvent
  ([type _uint32]
   [timestamp _uint32]
   [touchId SDL_TouchID]
   [gestureId SDL_GestureID]
   [numFingers _uint32]
   [error _float]
   [x _float]
   [y _float]))

(define-cstruct _SDL_DropEvent
  ([type _uint32]
   [timestamp _uint32]
   [file _string]))


(define-cstruct _SDL_QuitEvent
  ([type _uint32]
   [timestamp _uint32]))


(define-cstruct _SDL_OSEvent
  ([type _uint32]
   [timestamp _uint32]))


(define-cstruct _SDL_UserEvent
  ([type _uint32]
   [timestamp _uint32]
   [windowID _uint32]
   [code _int32]
   [data1 _pointer]
   [data2 _pointer]))


(define SDL_SysWMmsg _pointer)

(define-cstruct _SDL_SysWMEvent
  ([type _uint32]
   [timestamp _uint32]
   [msg SDL_SysWMmsg]))


(define _SDL_Event
  (_union _uint32 ;type
          _SDL_CommonEvent ;common
          _SDL_WindowEvent ;window
          _SDL_KeyboardEvent ;key
          _SDL_TextEditingEvent ;edit
          _SDL_TextInputEvent ;text
          _SDL_MouseMotionEvent ;motion
          _SDL_MouseButtonEvent ;button
          _SDL_MouseWheelEvent ;wheel
          _SDL_JoyAxisEvent ;jaxis
          _SDL_JoyBallEvent ;jball
          _SDL_JoyHatEvent ;jhat
          _SDL_JoyButtonEvent ;jbutton
          _SDL_JoyDeviceEvent ;jdevice
          _SDL_ControllerAxisEvent ;caxis
          _SDL_ControllerButtonEvent ;cbutton
          _SDL_ControllerDeviceEvent ;cdevice
          _SDL_QuitEvent ;quit
          _SDL_UserEvent ;user
          _SDL_SysWMEvent ;syswm
          _SDL_TouchFingerEvent ;tfinger
          _SDL_MultiGestureEvent ;mgesture
          _SDL_DollarGestureEvent ;dgesture
          _SDL_DropEvent ;drop
          (make-array-type _uint8 56)))  ;padding

(define-cpointer-type _SDL_Event*)


; SDL_stdinc.h

(define SDL_iconv_t _pointer)


; SDL_messagebox.h


(define-cstruct _SDL_MessageBoxButtonData
  ([flags _uint32]
   [buttonid _int]
   [text _string]))


(define-cstruct _SDL_MessageBoxColor
  ([r _uint8]
   [g _uint8]
   [b _uint8]))


(define-cstruct _SDL_MessageBoxColorScheme
  ([colors (make-array-type _SDL_MessageBoxColor SDL_MESSAGEBOX_COLOR_MAX)]))


(define-cstruct _SDL_MessageBoxData
  ([flags _uint32]
   [window _SDL_Window]
   [title _string]
   [message _string]
   [numbuttons _int]
   [buttons _SDL_MessageBoxButtonData-pointer]
   [colorScheme _SDL_MessageBoxColorScheme-pointer]))


; SDL_render.h

(define-cstruct _SDL_RendererInfo
  ([name _string]
   [flags _uint32]
   [num_texture_formats _uint32]
   [texture_formats (make-array-type _uint32 16)]
   [max_texture_width _int]
   [max_texture_height _int]))

(define _SDL_Renderer _pointer)
(define _SDL_Texture _pointer)

; SDL_shape.h

(define _SDL_WindowShapeParams (_union _uint8 _SDL_Color))

(define-cstruct _SDL_WindowShapeMode
  ([mode _WindowShapeMode]
   [parameters _SDL_WindowShapeParams]))


; SDL_timer.h

(define SDL_TimerID _int)


