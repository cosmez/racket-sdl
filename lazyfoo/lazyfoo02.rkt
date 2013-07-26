#lang racket
(require "../sdl/main.rkt")

(define *SCREEN_WIDTH* 640)
(define *SCREEN_HEIGHT* 480)

(define sdl-window #f)
(define screen-surface #f)
(define hello-world-surface #f)

(define (init) 
  (SDL_Init SDL_INIT_VIDEO)
  (set! sdl-window (SDL_CreateWindow "SDL Tutorial" SDL_WINDOWPOS_UNDEFINED SDL_WINDOWPOS_UNDEFINED *SCREEN_WIDTH* *SCREEN_HEIGHT* #x00000004))
  (if sdl-window
      (set! screen-surface (SDL_GetWindowSurface sdl-window))
      (printf "Window could not be created! SDL_Error: ~a\n" (SDL_GetError)))
  #t)

(define (load-media)
  (set! hello-world-surface (SDL_LoadBMP (path->string (build-path (current-directory) "hello_world.bmp")) ))
  (if hello-world-surface
      #t
      (printf "Unable to load image! SDL Error: ~a\n" (SDL_GetError))))

(define (close) 
  (SDL_FreeSurface hello-world-surface)
  (SDL_DestroyWindow sdl-window)
  (SDL_Quit))


(init)
(load-media)
(SDL_BlitSurface hello-world-surface #f screen-surface #f)
(SDL_UpdateWindowSurface sdl-window)
(SDL_Delay 2000)
(close)