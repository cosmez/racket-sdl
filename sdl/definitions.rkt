#lang racket

(require  
  ffi/unsafe
  ffi/unsafe/define
  ffi/cvector
  ffi/unsafe/cvector)
(require "constants.rkt" "structs.rkt")

(provide 
 (all-defined-out)
 (all-from-out "constants.rkt" "structs.rkt"))

;load ffi dll lib
(define (sdl-get-lib)
  (let ([type (system-type 'os)])
    (case type
      [(unix)     "libSDL2"]
      [(windows)  "SDL2"]
      [(macosx)   "libSDL2"]
      [else (error "Platform not supported: " type)])))

(define-ffi-definer define-sdl (ffi-lib (sdl-get-lib) #f))

(struct sdl-version (major minor patch) #:transparent)

(define-syntax-rule (sdl-error e)
  (when e
    (error 'sdl (SDL_GetError))))

;;;
;;; Get C Definitions out
;;;


;;; SDL.h
;extern DECLSPEC int SDLCALL SDL_Init(Uint32 flags);
(define-sdl SDL_Init (_fun _uint32 -> [e : _bool]
                           -> (sdl-error e)))
;extern DECLSPEC int SDLCALL SDL_InitSubSystem(Uint32 flags);
(define-sdl SDL_InitSubSystem (_fun _uint32 -> [e : _bool]
                                    -> (sdl-error e)))
;extern DECLSPEC void SDLCALL SDL_QuitSubSystem(Uint32 flags);
(define-sdl SDL_QuitSubSystem (_fun _uint32 -> _void))
;extern DECLSPEC Uint32 SDLCALL SDL_WasInit(Uint32 flags);
(define-sdl SDL_WasInit (_fun _uint32 -> _uint32))
;extern DECLSPEC void SDLCALL SDL_Quit(void);
(define-sdl SDL_Quit (_fun -> _void))

;SDL_Platform.h

(define-sdl SDL_GetPlatform  (_fun -> _string))

; SDL_Main.h
;extern DECLSPEC void SDL_SetMainReady(void);
(define-sdl SDL_SetMainReady (_fun -> _void))

; SDL_version.h
;extern DECLSPEC int SDLCALL SDL_GetRevisionNumber(void);
(define-sdl SDL_GetRevisionNumber (_fun -> _int))
;extern DECLSPEC void SDLCALL SDL_GetVersion(SDL_version * ver);
(define-sdl SDL_GetVersion (_fun _SDL_version-pointer -> _void))
;extern DECLSPEC const char *SDLCALL SDL_GetRevision(void);
(define-sdl SDL_GetRevision (_fun -> _string))


;SDL_rwops.h
;extern DECLSPEC SDL_RWops *SDLCALL SDL_RWFromFile(const char *file, const char *mode);
(define-sdl SDL_RWFromFile (_fun _string _string -> _pointer))
;extern DECLSPEC SDL_RWops *SDLCALL SDL_AllocRW(void);
(define-sdl SDL_AllocRW (_fun -> _pointer))
;extern DECLSPEC void SDLCALL SDL_FreeRW(SDL_RWops * area);
(define-sdl SDL_FreeRW (_fun _pointer -> _void))

;;; SDL_pixels.h
;extern DECLSPEC const char* SDLCALL SDL_GetPixelFormatName(Uint32 format);
(define-sdl SDL_GetPixelFormatName (_fun _uint32 -> _string))
;SDL_bool SDLCALL SDL_PixelFormatEnumToMasks(Uint32 format, int *bpp,Uint32 * Rmask,Uint32 * Gmask,Uint32 * Bmask, Uint32 * Amask);
(define-sdl SDL_PixelFormatEnumToMasks (_fun _uint32 _uint32* _uint32* _uint32* _uint32*  -> _bool))
;Uint32 SDL_MasksToPixelFormatEnum(int bpp, Uint32 Rmask, Uint32 Gmask,Uint32 Bmask,Uint32 Amask);
(define-sdl SDL_MasksToPixelFormatEnum (_fun _int _uint32 _uint32 _uint32 _uint32  -> _uint32))
;extern DECLSPEC SDL_PixelFormat * SDLCALL SDL_AllocFormat(Uint32 pixel_format);
(define-sdl SDL_AllocFormat (_fun _uint32  -> _SDL_PixelFormat-pointer))
;extern DECLSPEC void SDLCALL SDL_FreeFormat(SDL_PixelFormat *format);
(define-sdl SDL_FreeFormat (_fun _SDL_PixelFormat-pointer  -> _void))
;extern DECLSPEC SDL_Palette *SDLCALL SDL_AllocPalette(int ncolors);
(define-sdl SDL_AllocPalette (_fun _int  -> _SDL_Palette-pointer))
;extern DECLSPEC int SDLCALL SDL_SetPixelFormatPalette(SDL_PixelFormat * format, SDL_Palette *palette);
(define-sdl SDL_SetPixelFormatPalette (_fun _SDL_PixelFormat-pointer _SDL_Palette-pointer  -> _int))
;extern DECLSPEC int SDLCALL SDL_SetPaletteColors(SDL_Palette * palette, const SDL_Color * colors, int firstcolor, int ncolors);
(define-sdl SDL_SetPaletteColors (_fun _SDL_Palette-pointer _SDL_Color-pointer _int _int  -> _int))
;extern DECLSPEC void SDLCALL SDL_FreePalette(SDL_Palette * palette)
(define-sdl SDL_FreePalette (_fun _SDL_Palette-pointer -> _void))
;extern DECLSPEC Uint32 SDLCALL SDL_MapRGB(const SDL_PixelFormat * format, Uint8 r, Uint8 g, Uint8 b);
(define-sdl SDL_MapRGB (_fun _SDL_PixelFormat-pointer _uint8 _uint8 _uint8 -> _uint32))
;extern DECLSPEC Uint32 SDLCALL SDL_MapRGBA(const SDL_PixelFormat * format, Uint8 r, Uint8 g, Uint8 b, Uint8 a);
(define-sdl SDL_MapRGBA (_fun _SDL_PixelFormat-pointer _uint8 _uint8 _uint8 _uint8 -> _uint32))
;extern DECLSPEC void SDLCALL SDL_GetRGB(Uint32 pixel, const SDL_PixelFormat * format, Uint8 * r, Uint8 * g, Uint8 * b);
(define-sdl SDL_GetRGB (_fun _uint32 _SDL_PixelFormat-pointer _uint8* _uint8* _uint8* -> _void))
;extern DECLSPEC void SDLCALL SDL_GetRGBA(Uint32 pixel, const SDL_PixelFormat * format, Uint8 * r, Uint8 * g, Uint8 * b, Uint8 * a);
(define-sdl SDL_GetRGBA (_fun _uint32 _SDL_PixelFormat-pointer _uint8* _uint8* _uint8* _uint8* -> _void))
;extern DECLSPEC void SDLCALL SDL_CalculateGammaRamp(float gamma, Uint16 * ramp);
(define-sdl SDL_CalculateGammaRamp (_fun _float _uint16* -> _void))

; SDL_rect.h
;extern DECLSPEC SDL_bool SDLCALL SDL_HasIntersection(const SDL_Rect * A, const SDL_Rect * B);
(define-sdl SDL_HasIntersection (_fun _SDL_Rect-pointer _SDL_Rect-pointer -> _bool))
;extern DECLSPEC SDL_bool SDLCALL SDL_IntersectRect(const SDL_Rect * A,  const SDL_Rect * B, SDL_Rect * result);
(define-sdl SDL_IntersectRect (_fun _SDL_Rect-pointer _SDL_Rect-pointer _SDL_Rect-pointer -> _bool))
;extern DECLSPEC void SDLCALL SDL_UnionRect(const SDL_Rect * A, const SDL_Rect * B, SDL_Rect * result);
(define-sdl SDL_UnionRect (_fun _SDL_Rect-pointer _SDL_Rect-pointer _SDL_Rect-pointer -> _void))
;extern DECLSPEC SDL_bool SDLCALL SDL_EnclosePoints(const SDL_Point * points,  int count, const SDL_Rect * clip,SDL_Rect * result);
(define-sdl SDL_EnclosePoints (_fun _SDL_Point-pointer _int _SDL_Rect-pointer _SDL_Rect-pointer -> _bool))
;extern DECLSPEC SDL_bool SDLCALL SDL_IntersectRectAndLine(const SDL_Rect * rect, int *X1, int *Y1, int *X2, int *Y2);
(define-sdl SDL_IntersectRectAndLine (_fun _SDL_Rect-pointer _int* _int* _int* _int* -> _bool))



; SDL_Surface.h
;extern DECLSPEC SDL_Surface *SDLCALL SDL_CreateRGBSurface (Uint32 flags, int width, int height, int depth, Uint32 Rmask, Uint32 Gmask, Uint32 Bmask, Uint32 Amask);
(define-sdl SDL_CreateRGBSurface (_fun _uint32 _int _int _int _uint32 _uint32 _uint32 _uint32 -> _SDL_Surface-pointer))
;extern DECLSPEC SDL_Surface *SDLCALL SDL_CreateRGBSurfaceFrom(void *pixels, int width,int height,int depth,int pitch,Uint32 Rmask,Uint32 Gmask,Uint32 Bmask,Uint32 Amask);
(define-sdl SDL_CreateRGBSurfaceFrom (_fun _pointer _int _int _int _int _uint32 _uint32 _uint32 _uint32 -> _SDL_Surface-pointer))
;extern DECLSPEC void SDLCALL SDL_FreeSurface(SDL_Surface * surface);
(define-sdl SDL_FreeSurface (_fun _SDL_Surface-pointer -> _void))
;extern DECLSPEC int SDLCALL SDL_SetSurfacePalette(SDL_Surface * surface, SDL_Palette * palette);
(define-sdl SDL_SetSurfacePalette (_fun _SDL_Surface-pointer _SDL_Palette-pointer -> _int))
;extern DECLSPEC int SDLCALL SDL_LockSurface(SDL_Surface * surface);
(define-sdl SDL_LockSurface (_fun _SDL_Surface-pointer -> _int))
;extern DECLSPEC void SDLCALL SDL_UnlockSurface(SDL_Surface * surface);
(define-sdl SDL_UnlockSurface (_fun _SDL_Surface-pointer -> _void))
;extern DECLSPEC SDL_Surface *SDLCALL SDL_LoadBMP_RW(SDL_RWops * src, int freesrc);
(define-sdl SDL_LoadBMP_RW (_fun _pointer _int -> _SDL_Surface-pointer))
;#define SDL_LoadBMP(file)   SDL_LoadBMP_RW(SDL_RWFromFile(file, "rb"), 1)
(define (SDL_LoadBMP file) (SDL_LoadBMP_RW (SDL_RWFromFile file "rb") 1))
;extern DECLSPEC int SDLCALL SDL_SaveBMP_RW (SDL_Surface * surface, SDL_RWops * dst, int freedst);
(define-sdl SDL_SaveBMP_RW (_fun _SDL_Surface-pointer _pointer _int -> _int))
;#define SDL_SaveBMP(surface, file) SDL_SaveBMP_RW(surface, SDL_RWFromFile(file, "wb"), 1)
(define (SDL_SaveBMP surface file) (SDL_SaveBMP_RW surface (SDL_RWFromFile file "wb") 1))
;extern DECLSPEC int SDLCALL SDL_SetSurfaceRLE(SDL_Surface * surface, int flag);
(define-sdl SDL_SetSurfaceRLE (_fun _SDL_Surface-pointer _int -> _int))
;extern DECLSPEC int SDLCALL SDL_SetColorKey(SDL_Surface * surface,int flag, Uint32 key);
(define-sdl SDL_SetColorKey (_fun _SDL_Surface-pointer _int _uint32 -> _int))
;extern DECLSPEC int SDLCALL SDL_GetColorKey(SDL_Surface * surface,Uint32 * key);
(define-sdl SDL_GetColorKey (_fun _SDL_Surface-pointer _uint32* -> _int))
;extern DECLSPEC int SDLCALL SDL_SetSurfaceColorMod(SDL_Surface * surface, Uint8 r, Uint8 g, Uint8 b);
(define-sdl SDL_SetSurfaceColorMod (_fun _SDL_Surface-pointer _uint8 _uint8 _uint8 -> _int))
;extern DECLSPEC int SDLCALL SDL_GetSurfaceColorMod(SDL_Surface * surface, Uint8 * r, Uint8 * g, Uint8 * b);
(define-sdl SDL_GetSurfaceColorMod (_fun _SDL_Surface-pointer _uint8* _uint8* _uint8* -> _int))
;extern DECLSPEC int SDLCALL SDL_SetSurfaceAlphaMod(SDL_Surface * surface, Uint8 alpha);
(define-sdl SDL_SetSurfaceAlphaMod (_fun _SDL_Surface-pointer _uint8 -> _int))
;extern DECLSPEC int SDLCALL SDL_GetSurfaceAlphaMod(SDL_Surface * surface, Uint8 * alpha);
(define-sdl SDL_GetSurfaceAlphaMod (_fun _SDL_Surface-pointer _uint8* -> _int))
;extern DECLSPEC int SDLCALL SDL_SetSurfaceBlendMode(SDL_Surface * surface, SDL_BlendMode blendMode);
(define-sdl SDL_SetSurfaceBlendMode (_fun _SDL_Surface-pointer _SDL_BlendMode -> _int))
;extern DECLSPEC int SDLCALL SDL_GetSurfaceBlendMode(SDL_Surface * surface, SDL_BlendMode *blendMode);
(define-sdl SDL_GetSurfaceBlendMode (_fun _SDL_Surface-pointer _pointer -> _int))
;extern DECLSPEC SDL_bool SDLCALL SDL_SetClipRect(SDL_Surface * surface, const SDL_Rect * rect);
(define-sdl SDL_SetClipRect (_fun _SDL_Surface-pointer _SDL_Rect-pointer -> _bool))
;extern DECLSPEC void SDLCALL SDL_GetClipRect(SDL_Surface * surface, SDL_Rect * rect);
(define-sdl SDL_GetClipRect (_fun _SDL_Surface-pointer _SDL_Rect-pointer -> _void))
;extern DECLSPEC SDL_Surface *SDLCALL SDL_ConvertSurface (SDL_Surface * src, SDL_PixelFormat * fmt, Uint32 flags);
(define-sdl SDL_ConvertSurface (_fun _SDL_Surface-pointer _SDL_PixelFormat-pointer _uint32 -> _SDL_Surface-pointer))
;extern DECLSPEC SDL_Surface *SDLCALL SDL_ConvertSurfaceFormat(SDL_Surface * src, Uint32 pixel_format, Uint32 flags);
(define-sdl SDL_ConvertSurfaceFormat (_fun _SDL_Surface-pointer _uint32 _uint32 -> _SDL_Surface-pointer))
;extern DECLSPEC int SDLCALL SDL_ConvertPixels(int width, int height, Uint32 src_format, const void * src, int src_pitch, Uint32 dst_format, void * dst, int dst_pitch);
(define-sdl SDL_ConvertPixels (_fun _int _int _uint32 _pointer _int _uint32 _pointer _int -> _int))
;extern DECLSPEC int SDLCALL SDL_FillRect (SDL_Surface * dst, const SDL_Rect * rect, Uint32 color);
(define-sdl SDL_FillRect (_fun _SDL_Surface-pointer _SDL_Rect-pointer/null _uint32 -> _int))
;extern DECLSPEC int SDLCALL SDL_FillRects (SDL_Surface * dst, const SDL_Rect * rects, int count, Uint32 color);
(define-sdl SDL_FillRects (_fun _SDL_Surface-pointer _SDL_Rect-pointer/null _int _uint32 -> _int))
;extern DECLSPEC int SDLCALL SDL_UpperBlit (SDL_Surface * src, const SDL_Rect * srcrect, SDL_Surface * dst, SDL_Rect * dstrect);
(define-sdl SDL_UpperBlit (_fun _SDL_Surface-pointer _SDL_Rect-pointer/null _SDL_Surface-pointer _SDL_Rect-pointer/null -> _int))
;#define SDL_BlitSurface SDL_UpperBlit
(define SDL_BlitSurface SDL_UpperBlit)
;extern DECLSPEC int SDLCALL SDL_LowerBlit (SDL_Surface * src, SDL_Rect * srcrect, SDL_Surface * dst, SDL_Rect * dstrect);
(define-sdl SDL_LowerBlit (_fun _SDL_Surface-pointer _SDL_Rect-pointer/null _SDL_Surface-pointer _SDL_Rect-pointer/null -> _int))
;extern DECLSPEC int SDLCALL SDL_UpperBlitScaled (SDL_Surface * src, const SDL_Rect * srcrect, SDL_Surface * dst, SDL_Rect * dstrect);
(define-sdl SDL_UpperBlitScaled (_fun _SDL_Surface-pointer _SDL_Rect-pointer/null _SDL_Surface-pointer _SDL_Rect-pointer/null -> _int))
;#define SDL_BlitScaled SDL_UpperBlitScaled
(define SDL_BlitScaled SDL_UpperBlitScaled)
;extern DECLSPEC int SDLCALL SDL_LowerBlitScaled (SDL_Surface * src, SDL_Rect * srcrect, SDL_Surface * dst, SDL_Rect * dstrect);
(define-sdl SDL_LowerBlitScaled (_fun _SDL_Surface-pointer _SDL_Rect-pointer _SDL_Surface-pointer _SDL_Rect-pointer -> _int))

; SDL_video.h
;extern DECLSPEC int SDLCALL SDL_GetNumVideoDrivers(void);
(define-sdl SDL_GetNumVideoDrivers (_fun -> _int))
;extern DECLSPEC const char *SDLCALL SDL_GetVideoDriver(int index);
(define-sdl SDL_GetVideoDriver (_fun _int -> _string))
;extern DECLSPEC int SDLCALL SDL_VideoInit(const char *driver_name);
(define-sdl SDL_VideoInit (_fun _string -> _int))
;extern DECLSPEC void SDLCALL SDL_VideoQuit(void);
(define-sdl SDL_VideoQuit (_fun -> _void))
;extern DECLSPEC const char *SDLCALL SDL_GetCurrentVideoDriver(void);
(define-sdl SDL_GetCurrentVideoDriver (_fun -> _string))
;extern DECLSPEC int SDLCALL SDL_GetNumVideoDisplays(void);
(define-sdl SDL_GetNumVideoDisplays (_fun -> _int))
;extern DECLSPEC const char * SDLCALL SDL_GetDisplayName(int displayIndex);
(define-sdl SDL_GetDisplayName (_fun _int -> _string))
;extern DECLSPEC int SDLCALL SDL_GetDisplayBounds(int displayIndex, SDL_Rect * rect);
(define-sdl SDL_GetDisplayBounds (_fun _int _SDL_Rect-pointer -> _int))
;extern DECLSPEC int SDLCALL SDL_GetNumDisplayModes(int displayIndex);
(define-sdl SDL_GetNumDisplayModes (_fun _int -> _int))
;extern DECLSPEC int SDLCALL SDL_GetDisplayMode(int displayIndex, int modeIndex, SDL_DisplayMode * mode);
(define-sdl SDL_GetDisplayMode (_fun _int _int _SDL_DisplayMode-pointer -> _int))
;extern DECLSPEC int SDLCALL SDL_GetDesktopDisplayMode(int displayIndex, SDL_DisplayMode * mode);
(define-sdl SDL_GetDesktopDisplayMode (_fun _int _SDL_DisplayMode-pointer -> _int))
;extern DECLSPEC int SDLCALL SDL_GetCurrentDisplayMode(int displayIndex, SDL_DisplayMode * mode);
(define-sdl SDL_GetCurrentDisplayMode (_fun _int _SDL_DisplayMode-pointer -> _int))
;extern DECLSPEC SDL_DisplayMode * SDLCALL SDL_GetClosestDisplayMode(int displayIndex, const SDL_DisplayMode * mode, SDL_DisplayMode * closest);
(define-sdl SDL_GetClosestDisplayMode (_fun _int _SDL_DisplayMode-pointer _SDL_DisplayMode-pointer -> _SDL_DisplayMode-pointer))
;extern DECLSPEC int SDLCALL SDL_GetWindowDisplayIndex(SDL_Window * window);
(define-sdl SDL_GetWindowDisplayIndex (_fun _SDL_Window -> _int))
;extern DECLSPEC int SDLCALL SDL_SetWindowDisplayMode(SDL_Window * window,  const SDL_DisplayMode* mode);
(define-sdl SDL_SetWindowDisplayMode (_fun _SDL_Window _SDL_DisplayMode-pointer -> _int))
;extern DECLSPEC int SDLCALL SDL_GetWindowDisplayMode(SDL_Window * window, SDL_DisplayMode * mode);
(define-sdl SDL_GetWindowDisplayMode (_fun _SDL_Window _SDL_DisplayMode-pointer -> _int))
;extern DECLSPEC Uint32 SDLCALL SDL_GetWindowPixelFormat(SDL_Window * window);
(define-sdl SDL_GetWindowPixelFormat (_fun _SDL_Window -> _uint32))
;extern DECLSPEC SDL_Window * SDLCALL SDL_CreateWindow(const char *title, int x, int y, int w, int h, Uint32 flags);
(define-sdl SDL_CreateWindow (_fun _string _int _int _int _int _uint32 -> _SDL_Window))
;extern DECLSPEC SDL_Window * SDLCALL SDL_CreateWindowFrom(const void *data);
(define-sdl SDL_CreateWindowFrom (_fun _pointer -> _SDL_Window))
;extern DECLSPEC Uint32 SDLCALL SDL_GetWindowID(SDL_Window * window);
(define-sdl SDL_GetWindowID (_fun _SDL_Window -> _uint32))
;extern DECLSPEC SDL_Window * SDLCALL SDL_GetWindowFromID(Uint32 id);
(define-sdl SDL_GetWindowFromID (_fun _uint32 -> _SDL_Window))
;extern DECLSPEC Uint32 SDLCALL SDL_GetWindowFlags(SDL_Window * window);
(define-sdl SDL_GetWindowFlags (_fun _SDL_Window -> _uint32))
;extern DECLSPEC void SDLCALL SDL_SetWindowTitle(SDL_Window * window, const char *title);
(define-sdl SDL_SetWindowTitle (_fun _SDL_Window _string -> _void))
;extern DECLSPEC const char *SDLCALL SDL_GetWindowTitle(SDL_Window * window);
(define-sdl SDL_GetWindowTitle (_fun _SDL_Window -> _string))
;extern DECLSPEC void SDLCALL SDL_SetWindowIcon(SDL_Window * window, SDL_Surface * icon);
(define-sdl SDL_SetWindowIcon (_fun _SDL_Window _SDL_Surface-pointer -> _void))
;extern DECLSPEC void* SDLCALL SDL_SetWindowData(SDL_Window * window, const char *name, void *userdata);
(define-sdl SDL_SetWindowData (_fun _SDL_Window _string _pointer -> _pointer))
;extern DECLSPEC void *SDLCALL SDL_GetWindowData(SDL_Window * window, const char *name);
(define-sdl SDL_GetWindowData (_fun _SDL_Window _string -> _pointer))
;extern DECLSPEC void SDLCALL SDL_SetWindowPosition(SDL_Window * window, int x, int y);
(define-sdl SDL_SetWindowPosition (_fun _SDL_Window _int _int -> _void))
;extern DECLSPEC void SDLCALL SDL_GetWindowPosition(SDL_Window * window, int *x, int *y);
(define-sdl SDL_GetWindowPosition (_fun _SDL_Window _int*  _int* -> _void))
;extern DECLSPEC void SDLCALL SDL_SetWindowSize(SDL_Window * window, int w, int h);
(define-sdl SDL_SetWindowSize (_fun _SDL_Window _int _int -> _void))
;extern DECLSPEC void SDLCALL SDL_GetWindowSize(SDL_Window * window, int *w, int *h);
(define-sdl SDL_GetWindowSize (_fun _SDL_Window _int*  _int* -> _void))
;extern DECLSPEC void SDLCALL SDL_SetWindowMinimumSize(SDL_Window * window, int min_w, int min_h);
(define-sdl SDL_SetWindowMinimumSize (_fun _SDL_Window _int _int -> _void))
;extern DECLSPEC void SDLCALL SDL_GetWindowMinimumSize(SDL_Window * window, int *w, int *h);
(define-sdl SDL_GetWindowMinimumSize (_fun _SDL_Window _int*  _int* -> _void))
;extern DECLSPEC void SDLCALL SDL_SetWindowMaximumSize(SDL_Window * window, int max_w, int max_h);
(define-sdl SDL_SetWindowMaximumSize (_fun _SDL_Window _int _int -> _void))
;extern DECLSPEC void SDLCALL SDL_GetWindowMaximumSize(SDL_Window * window, int *w, int *h);
(define-sdl SDL_GetWindowMaximumSize (_fun _SDL_Window _int*  _int* -> _void))
;extern DECLSPEC void SDLCALL SDL_SetWindowBordered(SDL_Window * window, SDL_bool bordered);
(define-sdl SDL_SetWindowBordered (_fun _SDL_Window _bool -> _void))
;extern DECLSPEC void SDLCALL SDL_ShowWindow(SDL_Window * window);
(define-sdl SDL_ShowWindow (_fun _SDL_Window -> _void))
;extern DECLSPEC void SDLCALL SDL_HideWindow(SDL_Window * window);
(define-sdl SDL_HideWindow (_fun _SDL_Window -> _void))
;extern DECLSPEC void SDLCALL SDL_RaiseWindow(SDL_Window * window);
(define-sdl SDL_RaiseWindow (_fun _SDL_Window -> _void))
;extern DECLSPEC void SDLCALL SDL_MaximizeWindow(SDL_Window * window);
(define-sdl SDL_MaximizeWindow (_fun _SDL_Window -> _void))
;extern DECLSPEC void SDLCALL SDL_MinimizeWindow(SDL_Window * window);
(define-sdl SDL_MinimizeWindow (_fun _SDL_Window -> _void))
;extern DECLSPEC void SDLCALL SDL_RestoreWindow(SDL_Window * window);
(define-sdl SDL_RestoreWindow (_fun _SDL_Window -> _void))
;extern DECLSPEC int SDLCALL SDL_SetWindowFullscreen(SDL_Window * window, Uint32 flags);
(define-sdl SDL_SetWindowFullscreen (_fun _SDL_Window _uint32 -> _int))
;extern DECLSPEC SDL_Surface * SDLCALL SDL_GetWindowSurface(SDL_Window * window);
(define-sdl SDL_GetWindowSurface (_fun _SDL_Window -> _SDL_Surface-pointer))
;extern DECLSPEC int SDLCALL SDL_UpdateWindowSurface(SDL_Window * window);
(define-sdl SDL_UpdateWindowSurface (_fun _SDL_Window -> _int))
;extern DECLSPEC int SDLCALL SDL_UpdateWindowSurfaceRects(SDL_Window * window, const SDL_Rect * rects, int numrects);
(define-sdl SDL_UpdateWindowSurfaceRects (_fun _SDL_Window _SDL_Rect-pointer _int -> _int))
;extern DECLSPEC void SDLCALL SDL_SetWindowGrab(SDL_Window * window, SDL_bool grabbed);
(define-sdl SDL_SetWindowGrab (_fun _SDL_Window _bool -> _void))
;extern DECLSPEC SDL_bool SDLCALL SDL_GetWindowGrab(SDL_Window * window);
(define-sdl SDL_GetWindowGrab (_fun _SDL_Window -> _bool))
;extern DECLSPEC int SDLCALL SDL_SetWindowBrightness(SDL_Window * window, float brightness);
(define-sdl SDL_SetWindowBrightness (_fun _SDL_Window _float -> _int))
;extern DECLSPEC float SDLCALL SDL_GetWindowBrightness(SDL_Window * window);
(define-sdl SDL_GetWindowBrightness (_fun _SDL_Window -> _float))
;extern DECLSPEC int SDLCALL SDL_SetWindowGammaRamp(SDL_Window * window, const Uint16 * red, const Uint16 * green, const Uint16 * blue);
(define-sdl SDL_SetWindowGammaRamp (_fun _SDL_Window _uint16* _uint16* _uint16* -> _int))
;extern DECLSPEC int SDLCALL SDL_GetWindowGammaRamp(SDL_Window * window, Uint16 * red, Uint16 * green, Uint16 * blue);
(define-sdl SDL_GetWindowGammaRamp (_fun _SDL_Window _uint16* _uint16* _uint16* -> _int))
;extern DECLSPEC void SDLCALL SDL_DestroyWindow(SDL_Window * window);
(define-sdl SDL_DestroyWindow (_fun _SDL_Window -> _void))
;extern DECLSPEC SDL_bool SDLCALL SDL_IsScreenSaverEnabled(void);
(define-sdl SDL_IsScreenSaverEnabled (_fun -> _bool))
;extern DECLSPEC void SDLCALL SDL_EnableScreenSaver(void);
(define-sdl SDL_EnableScreenSaver (_fun -> _void))
;extern DECLSPEC void SDLCALL SDL_DisableScreenSaver(void);
(define-sdl SDL_DisableScreenSaver (_fun -> _void))
;extern DECLSPEC int SDLCALL SDL_GL_LoadLibrary(const char *path);
(define-sdl SDL_GL_LoadLibrary (_fun _string -> _int))
;extern DECLSPEC void *SDLCALL SDL_GL_GetProcAddress(const char *proc);
(define-sdl SDL_GL_GetProcAddress (_fun _string -> _pointer))
;extern DECLSPEC void SDLCALL SDL_GL_UnloadLibrary(void);
(define-sdl SDL_GL_UnloadLibrary (_fun -> _void))
;extern DECLSPEC SDL_bool SDLCALL SDL_GL_ExtensionSupported(const char *extension);
(define-sdl SDL_GL_ExtensionSupported (_fun _string -> _bool))
;extern DECLSPEC int SDLCALL SDL_GL_SetAttribute(SDL_GLattr attr, int value);
(define-sdl SDL_GL_SetAttribute (_fun _SDL_GLattr _int -> _int))
;extern DECLSPEC int SDLCALL SDL_GL_GetAttribute(SDL_GLattr attr, int *value);
(define-sdl SDL_GL_GetAttribute (_fun _SDL_GLattr _int* -> _int))
;extern DECLSPEC SDL_GLContext SDLCALL SDL_GL_CreateContext(SDL_Window * window);
(define-sdl SDL_GL_CreateContext (_fun _SDL_Window -> _SDL_GLContext))
;extern DECLSPEC int SDLCALL SDL_GL_MakeCurrent(SDL_Window * window, SDL_GLContext context);
(define-sdl SDL_GL_MakeCurrent (_fun _SDL_Window _SDL_GLContext -> _int))
;extern DECLSPEC int SDLCALL SDL_GL_SetSwapInterval(int interval);
(define-sdl SDL_GL_SetSwapInterval (_fun _int -> _int))
;extern DECLSPEC int SDLCALL SDL_GL_GetSwapInterval(void);
(define-sdl SDL_GL_GetSwapInterval (_fun -> _int))
;extern DECLSPEC void SDLCALL SDL_GL_SwapWindow(SDL_Window * window);
(define-sdl SDL_GL_SwapWindow (_fun _SDL_Window -> _void))
;extern DECLSPEC void SDLCALL SDL_GL_DeleteContext(SDL_GLContext context);
(define-sdl SDL_GL_DeleteContext (_fun _SDL_GLContext -> _void))

;SDL_audio.h
;extern DECLSPEC int SDLCALL SDL_GetNumAudioDrivers(void);
(define-sdl SDL_GetNumAudioDrivers (_fun -> _int))
;extern DECLSPEC const char *SDLCALL SDL_GetAudioDriver(int index);
(define-sdl SDL_GetAudioDriver (_fun _int -> _string))
;extern DECLSPEC int SDLCALL SDL_AudioInit(const char *driver_name);
(define-sdl SDL_AudioInit (_fun _string -> _int))
;extern DECLSPEC void SDLCALL SDL_AudioQuit(void);
(define-sdl SDL_AudioQuit (_fun -> _void))
;extern DECLSPEC const char *SDLCALL SDL_GetCurrentAudioDriver(void);
(define-sdl SDL_GetCurrentAudioDriver (_fun -> _string))
;extern DECLSPEC int SDLCALL SDL_OpenAudio(SDL_AudioSpec * desired, SDL_AudioSpec * obtained);
(define-sdl SDL_OpenAudio (_fun _SDL_AudioSpec-pointer _SDL_AudioSpec-pointer -> _int))
;extern DECLSPEC int SDLCALL SDL_GetNumAudioDevices(int iscapture);
(define-sdl SDL_GetNumAudioDevices (_fun _int -> _int))
;extern DECLSPEC const char *SDLCALL SDL_GetAudioDeviceName(int index, int iscapture);
(define-sdl SDL_GetAudioDeviceName (_fun _int _int -> _string))
;extern DECLSPEC SDL_AudioDeviceID SDLCALL SDL_OpenAudioDevice(const char *device, int iscapture, const SDL_AudioSpec * desired, SDL_AudioSpec * obtained, int allowed_changes);
(define-sdl SDL_OpenAudioDevice (_fun _string _int _SDL_AudioSpec-pointer _SDL_AudioSpec-pointer _int -> SDL_AudioDeviceID))
;extern DECLSPEC SDL_AudioStatus SDLCALL SDL_GetAudioStatus(void);
(define-sdl SDL_GetAudioStatus (_fun -> _SDL_AudioStatus))
;extern DECLSPEC SDL_AudioStatus SDLCALL SDL_GetAudioDeviceStatus(SDL_AudioDeviceID dev);
(define-sdl SDL_GetAudioDeviceStatus (_fun SDL_AudioDeviceID -> _SDL_AudioStatus))
;extern DECLSPEC void SDLCALL SDL_PauseAudio(int pause_on);
(define-sdl SDL_PauseAudio (_fun _int -> _void))
;extern DECLSPEC void SDLCALL SDL_PauseAudioDevice(SDL_AudioDeviceID dev, int pause_on);
(define-sdl SDL_PauseAudioDevice (_fun SDL_AudioDeviceID _int -> _void))
;extern DECLSPEC SDL_AudioSpec *SDLCALL SDL_LoadWAV_RW(SDL_RWops * src, int freesrc, SDL_AudioSpec * spec, Uint8 ** audio_buf, Uint32 * audio_len);
(define-sdl SDL_LoadWAV_RW (_fun _pointer _int _SDL_AudioSpec-pointer _pointer _uint32* -> _void))
;extern DECLSPEC void SDLCALL SDL_FreeWAV(Uint8 * audio_buf);
(define-sdl SDL_FreeWAV (_fun _uint8* -> _void))
;#define SDL_LoadWAV(file, spec, audio_buf, audio_len) SDL_LoadWAV_RW(SDL_RWFromFile(file, "rb"),1, spec,audio_buf,audio_len)
(define (SDL_LoadWAV file spec audio_buf audio_len) (SDL_LoadBMP_RW (SDL_RWFromFile file "rb") spec audio_buf audio_len))
;extern DECLSPEC int SDLCALL SDL_BuildAudioCVT(SDL_AudioCVT * cvt, SDL_AudioFormat src_format, Uint8 src_channels, int src_rate, SDL_AudioFormat dst_format, Uint8 dst_channels, int dst_rate);
(define-sdl SDL_BuildAudioCVT (_fun _SDL_AudioCVT-pointer _SDL_AudioFormat _uint8 _int _SDL_AudioFormat _uint8 _int -> _int))
;extern DECLSPEC int SDLCALL SDL_ConvertAudio(SDL_AudioCVT * cvt);
(define-sdl SDL_ConvertAudio (_fun _SDL_AudioCVT-pointer -> _int))
;extern DECLSPEC void SDLCALL SDL_MixAudio(Uint8 * dst, const Uint8 * src, Uint32 len, int volume);
(define-sdl SDL_MixAudio (_fun _uint8* _uint8* _uint32 _int  -> _void))
;extern DECLSPEC void SDLCALL SDL_MixAudioFormat(Uint8 * dst, const Uint8 * src, SDL_AudioFormat format, Uint32 len, int volume);
(define-sdl SDL_MixAudioFormat (_fun _uint8* _uint8* _SDL_AudioFormat _uint32 _int  -> _void))
;extern DECLSPEC void SDLCALL SDL_LockAudio(void);
(define-sdl SDL_LockAudio (_fun -> _void))
;extern DECLSPEC void SDLCALL SDL_LockAudioDevice(SDL_AudioDeviceID dev);
(define-sdl SDL_LockAudioDevice (_fun SDL_AudioDeviceID -> _void))
;extern DECLSPEC void SDLCALL SDL_UnlockAudio(void);
(define-sdl SDL_UnlockAudio (_fun -> _void))
;extern DECLSPEC void SDLCALL SDL_UnlockAudioDevice(SDL_AudioDeviceID dev);
(define-sdl SDL_UnlockAudioDevice (_fun SDL_AudioDeviceID -> _void))
;extern DECLSPEC void SDLCALL SDL_CloseAudio(void);
(define-sdl SDL_CloseAudio (_fun -> _void))
;extern DECLSPEC void SDLCALL SDL_CloseAudioDevice(SDL_AudioDeviceID dev);
(define-sdl SDL_CloseAudioDevice (_fun SDL_AudioDeviceID -> _void))
;extern DECLSPEC int SDLCALL SDL_AudioDeviceConnected(SDL_AudioDeviceID dev);
;(define-sdl SDL_AudioDeviceConnected (_fun SDL_AudioDeviceID -> _int))


;SDL_clipboard.h

;extern DECLSPEC int SDLCALL SDL_SetClipboardText(const char *text);
(define-sdl SDL_SetClipboardText (_fun _string -> _int))
;extern DECLSPEC char * SDLCALL SDL_GetClipboardText(void);
(define-sdl SDL_GetClipboardText (_fun -> _string))
;extern DECLSPEC SDL_bool SDLCALL SDL_HasClipboardText(void);
(define-sdl SDL_HasClipboardText (_fun -> _bool))


;SDL_cpuinfo.h
;extern DECLSPEC int SDLCALL SDL_GetCPUCount(void);
(define-sdl SDL_GetCPUCount (_fun -> _int))
;extern DECLSPEC int SDLCALL SDL_GetCPUCacheLineSize(void);
(define-sdl SDL_GetCPUCacheLineSize (_fun -> _int))
;extern DECLSPEC SDL_bool SDLCALL SDL_HasRDTSC(void);
(define-sdl SDL_HasRDTSC (_fun -> _bool))
;extern DECLSPEC SDL_bool SDLCALL SDL_HasAltiVec(void);
(define-sdl SDL_HasAltiVec (_fun -> _bool))
;extern DECLSPEC SDL_bool SDLCALL SDL_HasMMX(void);
(define-sdl SDL_HasMMX (_fun -> _bool))
;extern DECLSPEC SDL_bool SDLCALL SDL_Has3DNow(void);
(define-sdl SDL_Has3DNow (_fun -> _bool))
;extern DECLSPEC SDL_bool SDLCALL SDL_HasSSE(void);
(define-sdl SDL_HasSSE (_fun -> _bool))
;extern DECLSPEC SDL_bool SDLCALL SDL_HasSSE2(void);
(define-sdl SDL_HasSSE2 (_fun -> _bool))
;extern DECLSPEC SDL_bool SDLCALL SDL_HasSSE3(void);
(define-sdl SDL_HasSSE3 (_fun -> _bool))
;extern DECLSPEC SDL_bool SDLCALL SDL_HasSSE41(void);
(define-sdl SDL_HasSSE41 (_fun -> _bool))
;extern DECLSPEC SDL_bool SDLCALL SDL_HasSSE42(void);
(define-sdl SDL_HasSSE42 (_fun -> _bool))

;SDL_error.h
;extern DECLSPEC int SDLCALL SDL_SetError(const char *fmt, ...);
(define-sdl SDL_SetError (_fun _string -> _int))
;extern DECLSPEC const char *SDLCALL SDL_GetError(void);
(define-sdl SDL_GetError (_fun -> _string))
;extern DECLSPEC void SDLCALL SDL_ClearError(void);
(define-sdl SDL_ClearError (_fun -> _void))
;extern DECLSPEC int SDLCALL SDL_Error(SDL_errorcode code);
(define-sdl SDL_Error (_fun _SDL_errorcode -> _int))


; SDL_keyboard.h
;extern DECLSPEC SDL_Window * SDLCALL SDL_GetKeyboardFocus(void);
(define-sdl SDL_GetKeyboardFocus (_fun -> _SDL_Window))
;extern DECLSPEC const Uint8 *SDLCALL SDL_GetKeyboardState(int *numkeys);
(define-sdl SDL_GetKeyboardState (_fun _int* -> _uint8*))
;extern DECLSPEC SDL_Keymod SDLCALL SDL_GetModState(void);
(define-sdl  SDL_GetModState (_fun -> SDL_Keymod))
;extern DECLSPEC void SDLCALL SDL_SetModState(SDL_Keymod modstate);
(define-sdl  SDL_SetModState (_fun SDL_Keymod -> _void))
;extern DECLSPEC SDL_Keycode SDLCALL SDL_GetKeyFromScancode(SDL_Scancode scancode);
(define-sdl  SDL_GetKeyFromScancode (_fun SDL_Scancode -> SDL_Keycode))
;extern DECLSPEC SDL_Scancode SDLCALL SDL_GetScancodeFromKey(SDL_Keycode key);
(define-sdl  SDL_GetScancodeFromKey (_fun SDL_Keycode -> SDL_Scancode))
;extern DECLSPEC const char *SDLCALL SDL_GetScancodeName(SDL_Scancode scancode);
(define-sdl  SDL_GetScancodeName (_fun SDL_Scancode -> _string))
;extern DECLSPEC SDL_Scancode SDLCALL SDL_GetScancodeFromName(const char *name);
(define-sdl  SDL_GetScancodeFromName (_fun _string -> SDL_Scancode))
;extern DECLSPEC const char *SDLCALL SDL_GetKeyName(SDL_Keycode key);
(define-sdl  SDL_GetKeyName (_fun SDL_Keycode -> _string))
;extern DECLSPEC SDL_Keycode SDLCALL SDL_GetKeyFromName(const char *name);
(define-sdl  SDL_GetKeyFromName (_fun _string -> SDL_Keycode))
;extern DECLSPEC void SDLCALL SDL_StartTextInput(void);
(define-sdl  SDL_StartTextInput (_fun -> _void))
;extern DECLSPEC SDL_bool SDLCALL SDL_IsTextInputActive(void);
(define-sdl  SDL_IsTextInputActive (_fun -> _bool))
;extern DECLSPEC void SDLCALL SDL_StopTextInput(void);
(define-sdl  SDL_StopTextInput (_fun -> _void))
;extern DECLSPEC void SDLCALL SDL_SetTextInputRect(SDL_Rect *rect);
(define-sdl  SDL_SetTextInputRect (_fun _SDL_Rect-pointer -> _void))
;extern DECLSPEC SDL_bool SDLCALL SDL_HasScreenKeyboardSupport(void);
(define-sdl  SDL_HasScreenKeyboardSupport (_fun -> _bool))
;extern DECLSPEC SDL_bool SDLCALL SDL_IsScreenKeyboardShown(SDL_Window *window);
(define-sdl  SDL_IsScreenKeyboardShown (_fun _SDL_Window -> _bool))


; SDL_mouse.h

;extern DECLSPEC SDL_Window * SDLCALL SDL_GetMouseFocus(void);
(define-sdl  SDL_GetMouseFocus (_fun -> _SDL_Window))
;extern DECLSPEC Uint32 SDLCALL SDL_GetMouseState(int *x, int *y);
(define-sdl  SDL_GetMouseState (_fun _int* _int* -> _uint32))
;extern DECLSPEC Uint32 SDLCALL SDL_GetRelativeMouseState(int *x, int *y);
(define-sdl  SDL_GetRelativeMouseState (_fun _int* _int* -> _uint32))
;extern DECLSPEC void SDLCALL SDL_WarpMouseInWindow(SDL_Window * window,
(define-sdl  SDL_WarpMouseInWindow (_fun _SDL_Window -> _void))
;extern DECLSPEC int SDLCALL SDL_SetRelativeMouseMode(SDL_bool enabled);
(define-sdl  SDL_SetRelativeMouseMode (_fun _bool -> _int))
;extern DECLSPEC SDL_bool SDLCALL SDL_GetRelativeMouseMode(void);
(define-sdl  SDL_GetRelativeMouseMode (_fun -> _bool))
;extern DECLSPEC SDL_Cursor *SDLCALL SDL_CreateCursor(const Uint8 * data, const Uint8 * mask, int w, int h, int hot_x, int hot_y);
(define-sdl  SDL_CreateCursor (_fun _uint8* _uint8* _int _int _int _int -> _SDL_Cursor))
;extern DECLSPEC SDL_Cursor *SDLCALL SDL_CreateColorCursor(SDL_Surface *surface,int hot_x, int hot_y);
(define-sdl  SDL_CreateColorCursor (_fun _SDL_Surface-pointer _int _int -> _SDL_Cursor))
;extern DECLSPEC SDL_Cursor *SDLCALL SDL_CreateSystemCursor(SDL_SystemCursor id);
(define-sdl  SDL_CreateSystemCursor (_fun _SDL_SystemCursor -> _SDL_Cursor))
;extern DECLSPEC void SDLCALL SDL_SetCursor(SDL_Cursor * cursor);
(define-sdl  SDL_SetCursor (_fun _SDL_Cursor -> _void))
;extern DECLSPEC SDL_Cursor *SDLCALL SDL_GetCursor(void);
(define-sdl  SDL_GetCursor (_fun  -> _SDL_Cursor))
;extern DECLSPEC SDL_Cursor *SDLCALL SDL_GetDefaultCursor(void);
(define-sdl  SDL_GetDefaultCursor (_fun  -> _SDL_Cursor))
;extern DECLSPEC void SDLCALL SDL_FreeCursor(SDL_Cursor * cursor);
(define-sdl  SDL_FreeCursor (_fun _SDL_Cursor -> _void))
;extern DECLSPEC int SDLCALL SDL_ShowCursor(int toggle);
(define-sdl  SDL_ShowCursor (_fun _int -> _int))


; SDL_joystick.h
;extern DECLSPEC int SDLCALL SDL_NumJoysticks(void);
(define-sdl  SDL_NumJoysticks (_fun -> _int))
;extern DECLSPEC const char *SDLCALL SDL_JoystickNameForIndex(int device_index);
(define-sdl  SDL_JoystickNameForIndex (_fun _int -> _string))
;extern DECLSPEC SDL_Joystick *SDLCALL SDL_JoystickOpen(int device_index);
(define-sdl  SDL_JoystickOpen (_fun _int -> _SDL_Joystick))
;extern DECLSPEC const char *SDLCALL SDL_JoystickName(SDL_Joystick * joystick);
(define-sdl  SDL_JoystickName (_fun _SDL_Joystick -> _string))
;extern DECLSPEC SDL_JoystickGUID SDLCALL SDL_JoystickGetDeviceGUID(int device_index);
(define-sdl  SDL_JoystickGetDeviceGUID (_fun _int -> _SDL_JoystickGUID))
;extern DECLSPEC SDL_JoystickGUID SDLCALL SDL_JoystickGetGUID(SDL_Joystick * joystick);
(define-sdl  SDL_JoystickGetGUID (_fun _SDL_Joystick -> _SDL_JoystickGUID))
;extern DECLSPEC void SDL_JoystickGetGUIDString(SDL_JoystickGUID guid, char *pszGUID, int cbGUID);
(define-sdl  SDL_JoystickGetGUIDString (_fun _SDL_JoystickGUID _string _int -> _void))
;extern DECLSPEC SDL_JoystickGUID SDLCALL SDL_JoystickGetGUIDFromString(const char *pchGUID);
(define-sdl  SDL_JoystickGetGUIDFromString (_fun _string -> _SDL_JoystickGUID))
;extern DECLSPEC SDL_bool SDLCALL SDL_JoystickGetAttached(SDL_Joystick * joystick);
(define-sdl  SDL_JoystickGetAttached (_fun _SDL_Joystick -> _bool))
;extern DECLSPEC SDL_JoystickID SDLCALL SDL_JoystickInstanceID(SDL_Joystick * joystick);
(define-sdl  SDL_JoystickInstanceID (_fun _SDL_Joystick -> SDL_JoystickID))
;extern DECLSPEC int SDLCALL SDL_JoystickNumAxes(SDL_Joystick * joystick);
(define-sdl  SDL_JoystickNumAxes (_fun _SDL_Joystick -> _int))
;extern DECLSPEC int SDLCALL SDL_JoystickNumBalls(SDL_Joystick * joystick);
(define-sdl  SDL_JoystickNumBalls (_fun _SDL_Joystick -> _int))
;extern DECLSPEC int SDLCALL SDL_JoystickNumHats(SDL_Joystick * joystick);
(define-sdl  SDL_JoystickNumHats (_fun _SDL_Joystick -> _int))
;extern DECLSPEC int SDLCALL SDL_JoystickNumButtons(SDL_Joystick * joystick);
(define-sdl  SDL_JoystickNumButtons (_fun _SDL_Joystick -> _int))
;extern DECLSPEC void SDLCALL SDL_JoystickUpdate(void);
(define-sdl  SDL_JoystickUpdate (_fun -> _void))
;extern DECLSPEC int SDLCALL SDL_JoystickEventState(int state);
(define-sdl  SDL_JoystickEventState (_fun _int -> _int))
;extern DECLSPEC Sint16 SDLCALL SDL_JoystickGetAxis(SDL_Joystick * joystick, int axis);
(define-sdl  SDL_JoystickGetAxis (_fun _SDL_Joystick _int -> _int16))
;extern DECLSPEC Uint8 SDLCALL SDL_JoystickGetHat(SDL_Joystick * joystick,int hat);
(define-sdl  SDL_JoystickGetHat (_fun _SDL_Joystick _int -> _uint8))
;extern DECLSPEC int SDLCALL SDL_JoystickGetBall(SDL_Joystick * joystick,int ball, int *dx, int *dy);
(define-sdl  SDL_JoystickGetBall (_fun _SDL_Joystick _int _int* _int* -> _int))
;extern DECLSPEC Uint8 SDLCALL SDL_JoystickGetButton(SDL_Joystick * joystick,int button);
(define-sdl  SDL_JoystickGetButton (_fun _SDL_Joystick _int -> _uint8))
;extern DECLSPEC void SDLCALL SDL_JoystickClose(SDL_Joystick * joystick);
(define-sdl  SDL_JoystickClose (_fun _SDL_Joystick -> _void))


; SDL_haptic.h

;extern DECLSPEC int SDLCALL SDL_NumHaptics(void);
(define-sdl SDL_NumHaptics (_fun -> _void))
;extern DECLSPEC const char *SDLCALL SDL_HapticName(int device_index);
(define-sdl SDL_HapticName (_fun _int -> _string))
;extern DECLSPEC SDL_Haptic *SDLCALL SDL_HapticOpen(int device_index);
(define-sdl SDL_HapticOpen (_fun _int -> _SDL_Haptic))
;extern DECLSPEC int SDLCALL SDL_HapticOpened(int device_index);
(define-sdl SDL_HapticOpened (_fun _int -> _int))
;extern DECLSPEC int SDLCALL SDL_HapticIndex(SDL_Haptic * haptic);
(define-sdl SDL_HapticIndex (_fun _SDL_Haptic -> _int))
;extern DECLSPEC int SDLCALL SDL_MouseIsHaptic(void);
(define-sdl SDL_MouseIsHaptic (_fun  -> _int))
;extern DECLSPEC SDL_Haptic *SDLCALL SDL_HapticOpenFromMouse(void);
(define-sdl SDL_HapticOpenFromMouse (_fun  -> _SDL_Haptic))
;extern DECLSPEC int SDLCALL SDL_JoystickIsHaptic(SDL_Joystick * joystick);
(define-sdl SDL_JoystickIsHaptic (_fun _SDL_Joystick -> _int))
;extern DECLSPEC SDL_Haptic *SDLCALL SDL_HapticOpenFromJoystick(SDL_Joystick *joystick);
(define-sdl SDL_HapticOpenFromJoystick (_fun _SDL_Joystick -> _SDL_Haptic))
;extern DECLSPEC void SDLCALL SDL_HapticClose(SDL_Haptic * haptic);
(define-sdl SDL_HapticClose (_fun _SDL_Haptic -> _void))
;extern DECLSPEC int SDLCALL SDL_HapticNumEffects(SDL_Haptic * haptic);
(define-sdl SDL_HapticNumEffects (_fun _SDL_Haptic -> _int))
;extern DECLSPEC int SDLCALL SDL_HapticNumEffectsPlaying(SDL_Haptic * haptic);
(define-sdl SDL_HapticNumEffectsPlaying (_fun _SDL_Haptic -> _int))
;extern DECLSPEC unsigned int SDLCALL SDL_HapticQuery(SDL_Haptic * haptic);
(define-sdl SDL_HapticQuery (_fun _SDL_Haptic -> _int))
;extern DECLSPEC int SDLCALL SDL_HapticNumAxes(SDL_Haptic * haptic);
(define-sdl SDL_HapticNumAxes (_fun _SDL_Haptic -> _int))
;extern DECLSPEC int SDLCALL SDL_HapticEffectSupported(SDL_Haptic * haptic,SDL_HapticEffect * effect);
(define-sdl SDL_HapticEffectSupported (_fun _SDL_Haptic _SDL_HapticEffect* -> _int))
;extern DECLSPEC int SDLCALL SDL_HapticNewEffect(SDL_Haptic * haptic, SDL_HapticEffect * effect);
(define-sdl SDL_HapticNewEffect (_fun _SDL_Haptic _SDL_HapticEffect* -> _int))
;extern DECLSPEC int SDLCALL SDL_HapticUpdateEffect(SDL_Haptic * haptic,  int effect, SDL_HapticEffect * data);
(define-sdl SDL_HapticUpdateEffect (_fun _SDL_Haptic _int _SDL_HapticEffect* -> _int))
;extern DECLSPEC int SDLCALL SDL_HapticRunEffect(SDL_Haptic * haptic,int effect, Uint32 iterations);
(define-sdl SDL_HapticRunEffect (_fun _SDL_Haptic _int _uint32 -> _int))
;extern DECLSPEC int SDLCALL SDL_HapticStopEffect(SDL_Haptic * haptic, int effect);
(define-sdl SDL_HapticStopEffect (_fun _SDL_Haptic _int -> _int))
;extern DECLSPEC void SDLCALL SDL_HapticDestroyEffect(SDL_Haptic * haptic, int effect);
(define-sdl SDL_HapticDestroyEffect (_fun _SDL_Haptic _int -> _void))
;extern DECLSPEC int SDLCALL SDL_HapticGetEffectStatus(SDL_Haptic * haptic,int effect);
(define-sdl SDL_HapticGetEffectStatus (_fun _SDL_Haptic _int -> _int))
;extern DECLSPEC int SDLCALL SDL_HapticSetGain(SDL_Haptic * haptic, int gain);
(define-sdl SDL_HapticSetGain (_fun _SDL_Haptic _int -> _int))
;extern DECLSPEC int SDLCALL SDL_HapticSetAutocenter(SDL_Haptic * haptic,int autocenter);
(define-sdl SDL_HapticSetAutocenter (_fun _SDL_Haptic _int -> _int))
;extern DECLSPEC int SDLCALL SDL_HapticPause(SDL_Haptic * haptic);
(define-sdl SDL_HapticPause (_fun _SDL_Haptic -> _int))
;extern DECLSPEC int SDLCALL SDL_HapticUnpause(SDL_Haptic * haptic);
(define-sdl SDL_HapticUnpause (_fun _SDL_Haptic -> _int))
;extern DECLSPEC int SDLCALL SDL_HapticStopAll(SDL_Haptic * haptic);
(define-sdl SDL_HapticStopAll (_fun _SDL_Haptic -> _int))
;extern DECLSPEC int SDLCALL SDL_HapticRumbleSupported(SDL_Haptic * haptic);
(define-sdl SDL_HapticRumbleSupported (_fun _SDL_Haptic -> _int))
;extern DECLSPEC int SDLCALL SDL_HapticRumbleInit(SDL_Haptic * haptic);
(define-sdl SDL_HapticRumbleInit (_fun _SDL_Haptic -> _int))
;extern DECLSPEC int SDLCALL SDL_HapticRumblePlay(SDL_Haptic * haptic, float strength, Uint32 length );
(define-sdl SDL_HapticRumblePlay (_fun _SDL_Haptic _float _uint32 -> _int))
;extern DECLSPEC int SDLCALL SDL_HapticRumbleStop(SDL_Haptic * haptic);
(define-sdl SDL_HapticRumbleStop (_fun _SDL_Haptic -> _int))


; SDL_gamecontroller.h

;extern DECLSPEC int SDLCALL SDL_GameControllerAddMapping( const char* mappingString );
(define-sdl  SDL_GameControllerAddMapping (_fun _string -> _int))
;extern DECLSPEC char * SDLCALL SDL_GameControllerMappingForGUID( SDL_JoystickGUID guid );
(define-sdl  SDL_GameControllerMappingForGUID (_fun _SDL_JoystickGUID -> _string))
;extern DECLSPEC char * SDLCALL SDL_GameControllerMapping( SDL_GameController * gamecontroller );
(define-sdl  SDL_GameControllerMapping (_fun _SDL_GameController -> _string))
;extern DECLSPEC SDL_bool SDLCALL SDL_IsGameController(int joystick_index);
(define-sdl  SDL_IsGameController (_fun _int -> _bool))
;extern DECLSPEC const char *SDLCALL SDL_GameControllerNameForIndex(int joystick_index);
(define-sdl  SDL_GameControllerNameForIndex (_fun _int -> _string))
;extern DECLSPEC SDL_GameController *SDLCALL SDL_GameControllerOpen(int joystick_index);
(define-sdl  SDL_GameControllerOpen (_fun _int -> _SDL_GameController))
;extern DECLSPEC const char *SDLCALL SDL_GameControllerName(SDL_GameController *gamecontroller);
(define-sdl  SDL_GameControllerName (_fun _SDL_GameController -> _string))
;extern DECLSPEC SDL_bool SDLCALL SDL_GameControllerGetAttached(SDL_GameController *gamecontroller);
(define-sdl  SDL_GameControllerGetAttached (_fun _SDL_GameController -> _bool))
;extern DECLSPEC SDL_Joystick *SDLCALL SDL_GameControllerGetJoystick(SDL_GameController *gamecontroller);
(define-sdl  SDL_GameControllerGetJoystick (_fun _SDL_GameController -> _SDL_Joystick))
;extern DECLSPEC int SDLCALL SDL_GameControllerEventState(int state);
(define-sdl  SDL_GameControllerEventState (_fun _int -> _int))
;extern DECLSPEC void SDLCALL SDL_GameControllerUpdate(void);
(define-sdl  SDL_GameControllerUpdate (_fun -> _void))
;extern DECLSPEC SDL_GameControllerAxis SDLCALL SDL_GameControllerGetAxisFromString(const char *pchString);
(define-sdl  SDL_GameControllerGetAxisFromString (_fun _string -> _SDL_GameControllerAxis))
;extern DECLSPEC const char* SDLCALL SDL_GameControllerGetStringForAxis(SDL_GameControllerAxis axis);
(define-sdl  SDL_GameControllerGetStringForAxis (_fun _SDL_GameControllerAxis -> _string))
;extern DECLSPEC SDL_GameControllerButtonBind SDLCALL SDL_GameControllerGetBindForAxis(SDL_GameController *gamecontroller, SDL_GameControllerAxis axis);
(define-sdl  SDL_GameControllerGetBindForAxis (_fun _SDL_GameController _SDL_GameControllerAxis -> _SDL_GameControllerButtonBind))
;extern DECLSPEC Sint16 SDLCALL SDL_GameControllerGetAxis(SDL_GameController *gamecontroller, SDL_GameControllerAxis axis);
(define-sdl  SDL_GameControllerGetAxis (_fun _SDL_GameController _SDL_GameControllerAxis -> _int16))
;extern DECLSPEC SDL_GameControllerButton SDLCALL SDL_GameControllerGetButtonFromString(const char *pchString);
(define-sdl  SDL_GameControllerGetButtonFromString (_fun _string -> _SDL_GameControllerButton))
;extern DECLSPEC const char* SDLCALL SDL_GameControllerGetStringForButton(SDL_GameControllerButton button);
(define-sdl  SDL_GameControllerGetStringForButton (_fun _SDL_GameControllerButton -> _string))
;extern DECLSPEC SDL_GameControllerButtonBind SDLCALL SDL_GameControllerGetBindForButton(SDL_GameController *gamecontroller, SDL_GameControllerButton button);
(define-sdl  SDL_GameControllerGetBindForButton (_fun _SDL_GameController _SDL_GameControllerButton -> _SDL_GameControllerButtonBind))
;extern DECLSPEC Uint8 SDLCALL SDL_GameControllerGetButton(SDL_GameController *gamecontroller, SDL_GameControllerButton button);
(define-sdl  SDL_GameControllerGetButton (_fun _SDL_GameController _SDL_GameControllerButton -> _uint8))
;extern DECLSPEC void SDLCALL SDL_GameControllerClose(SDL_GameController *gamecontroller);
(define-sdl  SDL_GameControllerClose (_fun _SDL_GameController -> _void))

; SDL_touch.h

;extern DECLSPEC int SDLCALL SDL_GetNumTouchDevices(void);
(define-sdl  SDL_GetNumTouchDevices (_fun -> _int))
;extern DECLSPEC SDL_TouchID SDLCALL SDL_GetTouchDevice(int index);
(define-sdl  SDL_GetTouchDevice (_fun _int -> SDL_TouchID))
;extern DECLSPEC int SDLCALL SDL_GetNumTouchFingers(SDL_TouchID touchID);
(define-sdl  SDL_GetNumTouchFingers (_fun SDL_TouchID -> _int))
;extern DECLSPEC SDL_Finger * SDLCALL SDL_GetTouchFinger(SDL_TouchID touchID, int index);
(define-sdl  SDL_GetTouchFinger (_fun SDL_TouchID _int -> _SDL_Finger-pointer))

; SDL_gesture.h

;extern DECLSPEC int SDLCALL SDL_RecordGesture(SDL_TouchID touchId);
(define-sdl  SDL_RecordGesture (_fun SDL_TouchID  -> _int))
;extern DECLSPEC int SDLCALL SDL_SaveAllDollarTemplates(SDL_RWops *src);
(define-sdl  SDL_SaveAllDollarTemplates (_fun _pointer  -> _int))
;extern DECLSPEC int SDLCALL SDL_SaveDollarTemplate(SDL_GestureID gestureId,SDL_RWops *src);
(define-sdl  SDL_SaveDollarTemplate (_fun SDL_GestureID _pointer  -> _int))
;extern DECLSPEC int SDLCALL SDL_LoadDollarTemplates(SDL_TouchID touchId, SDL_RWops *src);
(define-sdl  SDL_LoadDollarTemplates (_fun SDL_TouchID _pointer  -> _int))

;extern DECLSPEC void SDLCALL SDL_PumpEvents(void);
(define-sdl  SDL_PumpEvents (_fun -> _void))
;extern DECLSPEC int SDLCALL SDL_PeepEvents(SDL_Event * events, int numevents, SDL_eventaction action, Uint32 minType, Uint32 maxType);
(define-sdl  SDL_PeepEvents (_fun _SDL_Event* _int _SDL_eventaction _uint32 _uint32 -> _int))
;extern DECLSPEC SDL_bool SDLCALL SDL_HasEvent(Uint32 type);
(define-sdl  SDL_HasEvent (_fun _uint32 -> _bool))
;extern DECLSPEC SDL_bool SDLCALL SDL_HasEvents(Uint32 minType, Uint32 maxType);
(define-sdl  SDL_HasEvents (_fun _uint32 _uint32 -> _bool))
;extern DECLSPEC void SDLCALL SDL_FlushEvent(Uint32 type);
(define-sdl  SDL_FlushEvent (_fun _uint32 -> _void))
;extern DECLSPEC void SDLCALL SDL_FlushEvents(Uint32 minType, Uint32 maxType);
(define-sdl  SDL_FlushEvents (_fun _uint32 _uint32 -> _void))
;extern DECLSPEC int SDLCALL SDL_PollEvent(SDL_Event * event);
(define-sdl  SDL_PollEvent (_fun _SDL_Event* -> _int))
;extern DECLSPEC int SDLCALL SDL_WaitEvent(SDL_Event * event);
(define-sdl  SDL_WaitEvent (_fun _SDL_Event* -> _int))
;extern DECLSPEC int SDLCALL SDL_WaitEventTimeout(SDL_Event * event, int timeout);
(define-sdl  SDL_WaitEventTimeout (_fun _SDL_Event* _int -> _int))
;extern DECLSPEC int SDLCALL SDL_PushEvent(SDL_Event * event);
(define-sdl  SDL_PushEvent (_fun _SDL_Event* -> _int))
;typedef int (SDLCALL * SDL_EventFilter) (void *userdata, SDL_Event * event);
(define SDL_EventFilter (_fun _pointer _SDL_Event* -> _int))
;extern DECLSPEC void SDLCALL SDL_SetEventFilter(SDL_EventFilter filter, void *userdata);
(define-sdl  SDL_SetEventFilter (_fun SDL_EventFilter _pointer -> _void))
;extern DECLSPEC SDL_bool SDLCALL SDL_GetEventFilter(SDL_EventFilter * filter,void **userdata);
(define-sdl  SDL_GetEventFilter (_fun _SDL_EventFilter* _pointer -> _bool))
;extern DECLSPEC void SDLCALL SDL_AddEventWatch(SDL_EventFilter filter, void *userdata);
(define-sdl  SDL_AddEventWatch (_fun SDL_EventFilter _pointer -> _void))
;extern DECLSPEC void SDLCALL SDL_DelEventWatch(SDL_EventFilter filter, void *userdata);
(define-sdl  SDL_DelEventWatch (_fun SDL_EventFilter _pointer -> _void))
;extern DECLSPEC void SDLCALL SDL_FilterEvents(SDL_EventFilter filter, void *userdata);
(define-sdl  SDL_FilterEvents (_fun SDL_EventFilter _pointer -> _void))
;extern DECLSPEC Uint8 SDLCALL SDL_EventState(Uint32 type, int state);
(define-sdl  SDL_EventState (_fun _uint32 _int -> _uint8))
;#define SDL_GetEventState(type) SDL_EventState(type, SDL_QUERY)
(define (SDL_GetEventState type) (SDL_EventState type SDL_QUERY))
;extern DECLSPEC Uint32 SDLCALL SDL_RegisterEvents(int numevents);
(define-sdl  SDL_RegisterEvents (_fun _int -> _uint32))


; SDL_hints.h

;SDL_bool  SDL_SetHintWithPriority(const char *name, const char *value, SDL_HintPriority priority);
(define-sdl SDL_SetHintWithPriority (_fun _string _string _SDL_HintPriority -> _bool))
;SDL_bool  SDL_SetHint(const char *name, const char *value);
(define-sdl SDL_SetHint (_fun _string _string -> _bool))
;const char *  SDL_GetHint(const char *name);
(define-sdl SDL_GetHint (_fun _string -> _string))
;void  SDL_ClearHints(void);
(define-sdl SDL_ClearHints (_fun -> _void))


; SDL_loadso.h

;extern DECLSPEC void *SDLCALL SDL_LoadObject(const char *sofile);
(define-sdl SDL_LoadObject (_fun _string -> _pointer))
;extern DECLSPEC void *SDLCALL SDL_LoadFunction(void *handle, const char *name);
(define-sdl SDL_LoadFunction (_fun _pointer _string -> _pointer))
;extern DECLSPEC void SDLCALL SDL_UnloadObject(void *handle);
(define-sdl SDL_UnloadObject (_fun _pointer -> _void))

; SDL_log.h

(define SDL_LogOutputFunction (_fun _pointer _int SDL_LogPriority _string -> _void))
;extern DECLSPEC void SDLCALL SDL_LogSetAllPriority(SDL_LogPriority priority);
(define-sdl SDL_LogSetAllPriority (_fun SDL_LogPriority -> _void))
;extern DECLSPEC void SDLCALL SDL_LogSetPriority(int category, SDL_LogPriority priority);
(define-sdl SDL_LogSetPriority (_fun _int  SDL_LogPriority -> _void))
;extern DECLSPEC SDL_LogPriority SDLCALL SDL_LogGetPriority(int category);
(define-sdl SDL_LogGetPriority (_fun _int -> SDL_LogPriority))
;extern DECLSPEC void SDLCALL SDL_LogResetPriorities(void);
(define-sdl SDL_LogResetPriorities (_fun -> _void))
;extern DECLSPEC void SDLCALL SDL_Log(const char *fmt, ...);
(define-sdl SDL_Log (_fun _string -> _void))
;extern DECLSPEC void SDLCALL SDL_LogVerbose(int category, const char *fmt, ...);
(define-sdl SDL_LogVerbose (_fun _int  _string -> _void))
;extern DECLSPEC void SDLCALL SDL_LogDebug(int category, const char *fmt, ...);
(define-sdl SDL_LogDebug (_fun _int  _string  -> _void))
;extern DECLSPEC void SDLCALL SDL_LogInfo(int category, const char *fmt, ...);
(define-sdl SDL_LogInfo (_fun _int  _string -> _void))
;extern DECLSPEC void SDLCALL SDL_LogWarn(int category, const char *fmt, ...);
(define-sdl SDL_LogWarn (_fun _int  _string -> _void))
;extern DECLSPEC void SDLCALL SDL_LogError(int category, const char *fmt, ...);
(define-sdl SDL_LogError (_fun _int  _string  -> _void))
;extern DECLSPEC void SDLCALL SDL_LogCritical(int category, const char *fmt, ...);
(define-sdl SDL_LogCritical (_fun _int  _string  -> _void))
;extern DECLSPEC void SDLCALL SDL_LogMessage(int category, SDL_LogPriority priority, const char *fmt, ...);
(define-sdl SDL_LogMessage (_fun _int SDL_LogPriority _string -> _void))
;extern DECLSPEC void SDLCALL SDL_LogMessageV(int category, SDL_LogPriority priority, const char *fmt, va_list ap);
;typedef void (*SDL_LogOutputFunction)(void *userdata, int category, SDL_LogPriority priority, const char *message);
;extern DECLSPEC void SDLCALL SDL_LogGetOutputFunction(SDL_LogOutputFunction *callback, void **userdata);
(define-sdl SDL_LogGetOutputFunction (_fun _SDL_LogOutputFunction* _pointer -> _void))
;extern DECLSPEC void SDLCALL SDL_LogSetOutputFunction(SDL_LogOutputFunction callback, void *userdata);
(define-sdl SDL_LogSetOutputFunction (_fun SDL_LogOutputFunction _pointer -> _void))

; SDL_stdinc.h

;extern DECLSPEC char *SDLCALL SDL_ulltoa(Uint64 value, char *str, int radix);
(define-sdl  SDL_ulltoa (_fun _uint64 _string _int -> _string))
;extern DECLSPEC Sint64 SDLCALL SDL_strtoll(const char *str, char **endp, int base);
(define-sdl  SDL_strtoll (_fun _string _pointer _int -> _int64))
;extern DECLSPEC Uint64 SDLCALL SDL_strtoull(const char *str, char **endp, int base);
(define-sdl  SDL_strtoull (_fun _string _pointer _int -> _uint64))
;extern DECLSPEC double SDLCALL SDL_strtod(const char *str, char **endp);
(define-sdl  SDL_strtod (_fun _string _pointer -> _double))
;extern DECLSPEC int SDLCALL SDL_atoi(const char *str);
(define-sdl  SDL_atoi (_fun _string -> _int))
;extern DECLSPEC double SDLCALL SDL_atof(const char *str);
(define-sdl  SDL_atof (_fun _string -> _double))
;extern DECLSPEC int SDLCALL SDL_strcmp(const char *str1, const char *str2);
(define-sdl  SDL_strcmp (_fun _string _string -> _int))
;extern DECLSPEC int SDLCALL SDL_strncmp(const char *str1, const char *str2, size_t maxlen);
(define-sdl  SDL_strncmp (_fun _string _string  _size -> _int))
;extern DECLSPEC int SDLCALL SDL_strcasecmp(const char *str1, const char *str2);
(define-sdl  SDL_strcasecmp (_fun _string _string  -> _int))
;extern DECLSPEC int SDLCALL SDL_strncasecmp(const char *str1, const char *str2, size_t len);
(define-sdl  SDL_strncasecmp (_fun _string _string _size -> _int))
;extern DECLSPEC int SDLCALL SDL_sscanf(const char *text, const char *fmt, ...);
; TODO
;extern DECLSPEC int SDLCALL SDL_snprintf(char *text, size_t maxlen, const char *fmt, ...);
; TODO
;extern DECLSPEC int SDLCALL SDL_vsnprintf(char *text, size_t maxlen, const char *fmt, va_list ap);
; TODO
;extern DECLSPEC double SDLCALL SDL_atan(double x);
(define SDL_atan atan)
;extern DECLSPEC double SDLCALL SDL_atan2(double x, double y);
(define SDL_atan2 atan)
;extern DECLSPEC double SDLCALL SDL_ceil(double x);
(define SDL_ceil ceiling)
;extern DECLSPEC double SDLCALL SDL_copysign(double x, double y);
(define-sdl  SDL_copysign (_fun _double _double  -> _double))
;extern DECLSPEC double SDLCALL SDL_cos(double x);
(define  SDL_cos cos)
;extern DECLSPEC float SDLCALL SDL_cosf(float x);
(define-sdl  SDL_cosf (_fun _float  -> _float))
;extern DECLSPEC double SDLCALL SDL_fabs(double x);
(define-sdl  SDL_fabs (_fun _double  -> _double))
;extern DECLSPEC double SDLCALL SDL_floor(double x);
(define  SDL_floor floor)
;extern DECLSPEC double SDLCALL SDL_log(double x);
(define  SDL_log log)
;extern DECLSPEC double SDLCALL SDL_pow(double x, double y);
(define  SDL_pow expt)
;extern DECLSPEC double SDLCALL SDL_scalbn(double x, int n);
(define-sdl  SDL_scalbn (_fun _double _double -> _double))
;extern DECLSPEC double SDLCALL SDL_sin(double x);
(define  SDL_sin sin)
;extern DECLSPEC float SDLCALL SDL_sinf(float x);
(define-sdl  SDL_sinf (_fun _float -> _float))
;extern DECLSPEC double SDLCALL SDL_sqrt(double x);
(define-sdl  SDL_sqrt (_fun _double -> _double))
;extern DECLSPEC SDL_iconv_t SDLCALL SDL_iconv_open(const char *tocode, const char *fromcode);
(define-sdl  SDL_iconv_open (_fun _string _string -> SDL_iconv_t))
;extern DECLSPEC int SDLCALL SDL_iconv_close(SDL_iconv_t cd);
(define-sdl  SDL_iconv_close (_fun SDL_iconv_t -> _int))
;extern DECLSPEC size_t SDLCALL SDL_iconv(SDL_iconv_t cd, const char **inbuf, size_t * inbytesleft, char **outbuf, size_t * outbytesleft);
(define-sdl  SDL_iconv (_fun SDL_iconv_t _pointer _size* _pointer _size* -> _size))
;extern DECLSPEC char *SDLCALL SDL_iconv_string(const char *tocode, const char *fromcode, const char *inbuf, size_t inbytesleft);
(define-sdl  SDL_iconv_string (_fun _string _string _string _size -> _string))


; SDL_messagebox.h
;extern DECLSPEC int SDLCALL SDL_ShowMessageBox(const SDL_MessageBoxData *messageboxdata, int *buttonid);
(define-sdl  SDL_ShowMessageBox (_fun _SDL_MessageBoxData-pointer _int* -> _int))
;extern DECLSPEC int SDLCALL SDL_ShowSimpleMessageBox(Uint32 flags, const char *title, const char *message, SDL_Window *window);
(define-sdl  SDL_ShowSimpleMessageBox (_fun _uint32 _string _string _SDL_Window -> _int))

; SDL_power.h

;extern DECLSPEC SDL_PowerState SDLCALL SDL_GetPowerInfo(int *secs, int *pct);
(define-sdl  SDL_GetPowerInfo (_fun _pointer _pointer  -> _SDL_PowerState))

; SDL_render.h

;extern DECLSPEC int SDLCALL SDL_GetNumRenderDrivers(void);
(define-sdl SDL_GetNumRenderDrivers (_fun -> _int))
;extern DECLSPEC int SDLCALL SDL_GetRenderDriverInfo(int index,SDL_RendererInfo * info);
(define-sdl SDL_GetRenderDriverInfo (_fun _int _SDL_RendererInfo-pointer -> _int))
;extern DECLSPEC int SDLCALL SDL_CreateWindowAndRenderer( int width, int height, Uint32 window_flags, SDL_Window **window, SDL_Renderer **renderer);
(define-sdl SDL_CreateWindowAndRenderer (_fun _int _int _uint32 _pointer _pointer -> _int))
;extern DECLSPEC SDL_Renderer * SDLCALL SDL_CreateRenderer(SDL_Window * window, int index, Uint32 flags);
(define-sdl SDL_CreateRenderer (_fun _SDL_Window _int _uint32 -> _SDL_Renderer))
;extern DECLSPEC SDL_Renderer * SDLCALL SDL_CreateSoftwareRenderer(SDL_Surface * surface);
(define-sdl SDL_CreateSoftwareRenderer (_fun _SDL_Surface-pointer -> _SDL_Renderer))
;extern DECLSPEC SDL_Renderer * SDLCALL SDL_GetRenderer(SDL_Window * window);
(define-sdl SDL_GetRenderer (_fun _SDL_Window -> _SDL_Renderer))
;extern DECLSPEC int SDLCALL SDL_GetRendererInfo(SDL_Renderer * renderer, SDL_RendererInfo * info);
(define-sdl SDL_GetRendererInfo (_fun _SDL_Renderer _SDL_RendererInfo-pointer -> _int))
;extern DECLSPEC int SDLCALL SDL_GetRendererOutputSize(SDL_Renderer * renderer, int *w, int *h);
(define-sdl SDL_GetRendererOutputSize (_fun _SDL_Renderer _int* _int* -> _int))
;extern DECLSPEC SDL_Texture * SDLCALL SDL_CreateTexture(SDL_Renderer * renderer, Uint32 format, int access, int w, int h);
(define-sdl SDL_CreateTexture (_fun _SDL_Renderer _uint32 _int _int _int -> _SDL_Texture))
;extern DECLSPEC SDL_Texture * SDLCALL SDL_CreateTextureFromSurface(SDL_Renderer * renderer, SDL_Surface * surface);
(define-sdl SDL_CreateTextureFromSurface (_fun _SDL_Renderer _SDL_Surface-pointer -> _SDL_Texture ))
;extern DECLSPEC int SDLCALL SDL_QueryTexture(SDL_Texture * texture, Uint32 * format, int *access, int *w, int *h);
(define-sdl SDL_QueryTexture (_fun _SDL_Texture _uint32* _int* _int* _int* -> _int))
;extern DECLSPEC int SDLCALL SDL_SetTextureColorMod(SDL_Texture * texture, Uint8 r, Uint8 g, Uint8 b);
(define-sdl SDL_SetTextureColorMod (_fun _SDL_Texture _uint8 _uint8 _uint8 -> _int))
;extern DECLSPEC int SDLCALL SDL_GetTextureColorMod(SDL_Texture * texture, Uint8 * r, Uint8 * g, Uint8 * b);
(define-sdl SDL_GetTextureColorMod (_fun _SDL_Texture _uint8* _uint8 _uint8 -> _int))
;extern DECLSPEC int SDLCALL SDL_SetTextureAlphaMod(SDL_Texture * texture, Uint8 alpha);
(define-sdl SDL_SetTextureAlphaMod (_fun _SDL_Texture _uint8 -> _int))
;extern DECLSPEC int SDLCALL SDL_GetTextureAlphaMod(SDL_Texture * texture, Uint8 * alpha);
(define-sdl SDL_GetTextureAlphaMod (_fun _SDL_Texture _uint8* -> _int))
;extern DECLSPEC int SDLCALL SDL_SetTextureBlendMode(SDL_Texture * texture, SDL_BlendMode blendMode);
(define-sdl SDL_SetTextureBlendMode (_fun _SDL_Texture _SDL_BlendMode -> _int))
;extern DECLSPEC int SDLCALL SDL_GetTextureBlendMode(SDL_Texture * texture, SDL_BlendMode *blendMode);
(define-sdl SDL_GetTextureBlendMode (_fun _SDL_Texture _pointer -> _int))
;extern DECLSPEC int SDLCALL SDL_UpdateTexture(SDL_Texture * texture, const SDL_Rect * rect, const void *pixels, int pitch);
(define-sdl SDL_UpdateTexture (_fun _SDL_Texture _SDL_Rect-pointer _pointer _int -> _int))
;extern DECLSPEC int SDLCALL SDL_LockTexture(SDL_Texture * texture, const SDL_Rect * rect, void **pixels, int *pitch);
(define-sdl SDL_LockTexture (_fun _SDL_Texture _SDL_Rect-pointer _pointer _int -> _int))
;extern DECLSPEC void SDLCALL SDL_UnlockTexture(SDL_Texture * texture);
(define-sdl SDL_UnlockTexture (_fun _pointer -> _void))
;extern DECLSPEC SDL_bool SDLCALL SDL_RenderTargetSupported(SDL_Renderer *renderer);
(define-sdl SDL_RenderTargetSupported (_fun _SDL_Renderer -> _bool))
;extern DECLSPEC int SDLCALL SDL_SetRenderTarget(SDL_Renderer *renderer, SDL_Texture *texture);
(define-sdl SDL_SetRenderTarget (_fun _SDL_Renderer _SDL_Texture -> _int))
;extern DECLSPEC SDL_Texture * SDLCALL SDL_GetRenderTarget(SDL_Renderer *renderer);
(define-sdl SDL_GetRenderTarget (_fun _SDL_Renderer -> _SDL_Texture ))
;extern DECLSPEC int SDLCALL SDL_RenderSetLogicalSize(SDL_Renderer * renderer, int w, int h);
(define-sdl SDL_RenderSetLogicalSize (_fun _SDL_Renderer _int _int -> _int))
;extern DECLSPEC void SDLCALL SDL_RenderGetLogicalSize(SDL_Renderer * renderer, int *w, int *h);
(define-sdl SDL_RenderGetLogicalSize (_fun _SDL_Renderer _int* _int* -> _void))
;extern DECLSPEC int SDLCALL SDL_RenderSetViewport(SDL_Renderer * renderer, const SDL_Rect * rect);
(define-sdl SDL_RenderSetViewport (_fun _SDL_Renderer _SDL_Rect-pointer -> _int))
;extern DECLSPEC void SDLCALL SDL_RenderGetViewport(SDL_Renderer * renderer, SDL_Rect * rect);
(define-sdl SDL_RenderGetViewport (_fun _SDL_Renderer _SDL_Rect-pointer -> _void  ))
;extern DECLSPEC int SDLCALL SDL_RenderSetClipRect(SDL_Renderer * renderer, const SDL_Rect * rect);
(define-sdl SDL_RenderSetClipRect (_fun _SDL_Renderer _SDL_Rect-pointer -> _int  ))
;extern DECLSPEC void SDLCALL SDL_RenderGetClipRect(SDL_Renderer * renderer, SDL_Rect * rect);
(define-sdl SDL_RenderGetClipRect (_fun _SDL_Renderer _SDL_Rect-pointer -> _void))
;extern DECLSPEC int SDLCALL SDL_RenderSetScale(SDL_Renderer * renderer, float scaleX, float scaleY);
(define-sdl SDL_RenderSetScale (_fun _SDL_Renderer _float _float -> _int))
;extern DECLSPEC void SDLCALL SDL_RenderGetScale(SDL_Renderer * renderer, float *scaleX, float *scaleY);
(define-sdl SDL_RenderGetScale (_fun _SDL_Renderer _float* _float* -> _void))
;extern DECLSPEC int SDL_SetRenderDrawColor(SDL_Renderer * renderer, Uint8 r, Uint8 g, Uint8 b, Uint8 a);
(define-sdl SDL_SetRenderDrawColor (_fun _SDL_Renderer _uint8 _uint8 _uint8 _uint8 -> _int ))
;extern DECLSPEC int SDL_GetRenderDrawColor(SDL_Renderer * renderer, Uint8 * r, Uint8 * g, Uint8 * b, Uint8 * a);
(define-sdl SDL_GetRenderDrawColor (_fun _SDL_Renderer _uint8* _uint8* _uint8* _uint8* -> _int))
;extern DECLSPEC int SDLCALL SDL_SetRenderDrawBlendMode(SDL_Renderer * renderer, SDL_BlendMode blendMode);
(define-sdl SDL_SetRenderDrawBlendMode (_fun _SDL_Renderer _SDL_BlendMode -> _int  ))
;extern DECLSPEC int SDLCALL SDL_GetRenderDrawBlendMode(SDL_Renderer * renderer, SDL_BlendMode *blendMode);
(define-sdl SDL_GetRenderDrawBlendMode (_fun _SDL_Renderer _pointer -> _int  ))
;extern DECLSPEC int SDLCALL SDL_RenderClear(SDL_Renderer * renderer);
(define-sdl SDL_RenderClear (_fun _SDL_Renderer -> _int  ))
;extern DECLSPEC int SDLCALL SDL_RenderDrawPoint(SDL_Renderer * renderer, int x, int y);
(define-sdl SDL_RenderDrawPoint (_fun _SDL_Renderer _int _int -> _int  ))
;extern DECLSPEC int SDLCALL SDL_RenderDrawPoints(SDL_Renderer * renderer, const SDL_Point * points, int count);
(define-sdl SDL_RenderDrawPoints (_fun _SDL_Renderer _SDL_Point-pointer _int -> _int))
;extern DECLSPEC int SDLCALL SDL_RenderDrawLine(SDL_Renderer * renderer, int x1, int y1, int x2, int y2);
(define-sdl SDL_RenderDrawLine (_fun _SDL_Renderer _int _int _int _int -> _int))
;extern DECLSPEC int SDLCALL SDL_RenderDrawLines(SDL_Renderer * renderer, const SDL_Point * points, int count);
(define-sdl SDL_RenderDrawLines (_fun _SDL_Renderer _SDL_Point-pointer _int -> _int  ))
;extern DECLSPEC int SDLCALL SDL_RenderDrawRect(SDL_Renderer * renderer, const SDL_Rect * rect);
(define-sdl SDL_RenderDrawRect (_fun _SDL_Renderer _SDL_Rect-pointer -> _int))
;extern DECLSPEC int SDLCALL SDL_RenderDrawRects(SDL_Renderer * renderer, const SDL_Rect * rects, int count);
(define-sdl SDL_RenderDrawRects (_fun _SDL_Renderer _SDL_Rect-pointer _int -> _int  ))
;extern DECLSPEC int SDLCALL SDL_RenderFillRect(SDL_Renderer * renderer, const SDL_Rect * rect);
(define-sdl SDL_RenderFillRect (_fun _SDL_Renderer _SDL_Rect-pointer -> _int  ))
;extern DECLSPEC int SDLCALL SDL_RenderFillRects(SDL_Renderer * renderer, const SDL_Rect * rects, int count);
(define-sdl SDL_RenderFillRects (_fun _SDL_Renderer _SDL_Rect-pointer _int -> _int  ))
;extern DECLSPEC int SDLCALL SDL_RenderCopy(SDL_Renderer * renderer, SDL_Texture * texture, const SDL_Rect * srcrect, const SDL_Rect * dstrect);
(define-sdl SDL_RenderCopy (_fun _SDL_Renderer _SDL_Texture _SDL_Rect-pointer _SDL_Rect-pointer -> _int))
;extern DECLSPEC int SDLCALL SDL_RenderCopyEx(SDL_Renderer * renderer, SDL_Texture * texture, const SDL_Rect * srcrect, const SDL_Rect * dstrect, const double angle, const SDL_Point *center, const SDL_RendererFlip flip);
(define-sdl SDL_RenderCopyEx (_fun _SDL_Renderer _SDL_Texture _SDL_Rect-pointer _SDL_Rect-pointer  _double _SDL_Point-pointer _SDL_RendererFlip -> _int))
;extern DECLSPEC int SDLCALL SDL_RenderReadPixels(SDL_Renderer * renderer, const SDL_Rect * rect, Uint32 format, void *pixels, int pitch);
(define-sdl SDL_RenderReadPixels (_fun _SDL_Renderer _SDL_Rect-pointer _uint32 _pointer _int -> _int))
;extern DECLSPEC void SDLCALL SDL_RenderPresent(SDL_Renderer * renderer);
(define-sdl SDL_RenderPresent (_fun _SDL_Renderer -> _void))
;extern DECLSPEC void SDLCALL SDL_DestroyTexture(SDL_Texture * texture);
(define-sdl SDL_DestroyTexture (_fun _SDL_Texture -> _void  ))
;extern DECLSPEC void SDLCALL SDL_DestroyRenderer(SDL_Renderer * renderer);
(define-sdl SDL_DestroyRenderer (_fun _SDL_Renderer -> _void))
;extern DECLSPEC int SDLCALL SDL_GL_BindTexture(SDL_Texture *texture, float *texw, float *texh);
(define-sdl SDL_GL_BindTexture (_fun _SDL_Texture _float* _float* -> _int))
;extern DECLSPEC int SDLCALL SDL_GL_UnbindTexture(SDL_Texture *texture);
(define-sdl SDL_GL_UnbindTexture (_fun _SDL_Texture -> _int))


; SDL_shape.h

;extern DECLSPEC SDL_Window * SDLCALL SDL_CreateShapedWindow(const char *title,unsigned int x,unsigned int y,unsigned int w,unsigned int h,Uint32 flags);
(define-sdl SDL_CreateShapedWindow (_fun _string _uint _uint _uint _uint _uint32 -> _SDL_Window))
;extern DECLSPEC SDL_bool SDLCALL SDL_IsShapedWindow(const SDL_Window *window);
(define-sdl SDL_IsShapedWindow (_fun _SDL_Window -> _bool))
;extern DECLSPEC int SDLCALL SDL_SetWindowShape(SDL_Window *window,SDL_Surface *shape,SDL_WindowShapeMode *shape_mode);
(define-sdl SDL_SetWindowShape (_fun _SDL_Window _SDL_Surface-pointer _SDL_WindowShapeMode-pointer -> _int))
;extern DECLSPEC int SDLCALL SDL_GetShapedWindowMode(SDL_Window *window,SDL_WindowShapeMode *shape_mode);
(define-sdl SDL_GetShapedWindowMode (_fun _SDL_Window _SDL_WindowShapeMode-pointer -> _int))

; SDL_timer.h

(define SDL_TimerCallback (_fun _uint32 _pointer -> _void))
;extern DECLSPEC Uint32 SDLCALL SDL_GetTicks(void);
(define-sdl SDL_GetTicks (_fun -> _uint32))
;extern DECLSPEC Uint64 SDLCALL SDL_GetPerformanceCounter(void);
(define-sdl SDL_GetPerformanceCounter (_fun -> _uint64))
;extern DECLSPEC Uint64 SDLCALL SDL_GetPerformanceFrequency(void);
(define-sdl SDL_GetPerformanceFrequency (_fun  -> _uint64))
;extern DECLSPEC void SDLCALL SDL_Delay(Uint32 ms);
(define-sdl SDL_Delay (_fun _uint32 -> _void))
;extern DECLSPEC SDL_TimerID SDLCALL SDL_AddTimer(Uint32 interval, SDL_TimerCallback callback, void *param);
(define-sdl SDL_AddTimer (_fun _uint32 SDL_TimerCallback _pointer -> SDL_TimerID))
;extern DECLSPEC SDL_bool SDLCALL SDL_RemoveTimer(SDL_TimerID id);
(define-sdl SDL_RemoveTimer (_fun SDL_TimerID -> _bool))


;;here we first define the structure pointer to send, once we get the data we print it as a racket struct
(define (sdl-get-version)
  (let* ([struct-pointer (make-SDL_version 0 0 0)])
    (SDL_GetVersion struct-pointer)
    (sdl-version (SDL_version-major struct-pointer) (SDL_version-minor struct-pointer) (SDL_version-patch struct-pointer))))





