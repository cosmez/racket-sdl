#lang racket
(require "../sdl/main.rkt")
(define width 640)
(define height 480)
(define error (SDL_Init SDL_INIT_VIDEO))
(display error)
(cond 
  [#f (printf "SDL could not initialize! SDL_Error: ~a\n" (SDL_GetError))]
  [else
   (define window (SDL_CreateWindow "SDL Tutorial" SDL_WINDOWPOS_UNDEFINED SDL_WINDOWPOS_UNDEFINED width height #x00000004))
   (cond
     [(equal? window #f) (printf "Window could not be created! SDL_Error: ~a\n" (SDL_GetError))]
     [else 
      (define surface (SDL_GetWindowSurface window))
      (SDL_FillRect surface #f (SDL_MapRGB (SDL_Surface-format surface) #x00 #xFF #xFF))
      (SDL_UpdateWindowSurface window)
      (SDL_Delay 2000)
      (SDL_DestroyWindow window)])])
(SDL_Quit)