module Flint.FMPZ
    ( FMPZ )
where

import Flint.FMPZ.FFI

import Foreign.C.Types (CLong(..))
import Foreign.C.String (peekCString)
import Foreign.Ptr (Ptr, nullPtr)
import Foreign.Marshal (alloca, with, free)
import Foreign.Storable (peek)

import Control.Monad (foldM)
import Control.Applicative ((<$>))
import System.IO.Unsafe (unsafePerformIO)

instance Num FMPZ where
    -- todo : speed this up
    fromInteger a | fromIntegral (minBound :: CLong) < a
                    && fromIntegral (maxBound :: CLong) > a
                  = withNewFMPZ_ $ \c -> fmpz_set_si c (fromInteger a)
                  | otherwise = withNewFMPZ_ $ \c ->
                                foldM (\b l -> alloca $ \lptr -> do
                                                 fmpz_init lptr
                                                 fmpz_set_si lptr (fromIntegral l)
                                                 fmpz_mul_si b b limbSize
                                                 fmpz_add b b lptr
                                                 return b)
                                c limbs
                  where
                    limbs = map fst $ takeWhile ((0/=) . snd) $
                            iterate (flip divMod (fromIntegral limbSize) . snd) (0,a)
                    limbSize = maxBound :: CLong
    (+) = lift2FMPZ_ fmpz_add
    (-) = lift2FMPZ_ fmpz_sub
    (*) = lift2FMPZ_ fmpz_mul
    abs = liftFMPZ_ fmpz_abs
    signum = fromInteger . fromIntegral . unsafePerformIO . (lift0FMPZ fmpz_sgn)
    negate = liftFMPZ_ fmpz_neg

instance Show FMPZ where
    show = show . flip toString 10

toString :: FMPZ -> Int -> String
toString a base = unsafePerformIO $ flip lift0FMPZ a $ \ptr -> do
  cstr <- fmpz_get_str nullPtr (fromIntegral base) ptr 
  str <- peekCString cstr
  free cstr
  return str
  

withNewFMPZ_ :: (Ptr CFMPZ -> IO a) -> FMPZ
withNewFMPZ_ = fst . withNewFMPZ

withNewFMPZ :: (Ptr CFMPZ -> IO a) -> (FMPZ, IO a)
withNewFMPZ f = (unsafePerformIO $ fst <$> res, snd <$> res)
    where
      res = alloca $ \ptr -> do
              fmpz_init ptr
              fres <- f ptr
              a <- peek ptr
              return (fromCFMPZ a, fres)

lift0FMPZ :: (Ptr CFMPZ -> IO a) -> FMPZ -> IO a
lift0FMPZ f a = with (toCFMPZ a) $ \aptr ->
                f aptr

liftFMPZ :: (Ptr CFMPZ -> Ptr CFMPZ -> IO a) -> FMPZ -> (FMPZ, IO a)
liftFMPZ f a = withNewFMPZ $ \cptr ->
               with (toCFMPZ a) $ \aptr ->
               f cptr aptr

liftFMPZ_ :: (Ptr CFMPZ -> Ptr CFMPZ -> IO a) -> FMPZ -> FMPZ
liftFMPZ_ f a = fst $ liftFMPZ f a

lift2FMPZ :: (Ptr CFMPZ -> Ptr CFMPZ -> Ptr CFMPZ -> IO a) -> FMPZ -> FMPZ -> (FMPZ, IO a)
lift2FMPZ f a b = withNewFMPZ $ \cptr ->
                  with (toCFMPZ a) $ \aptr ->
                  with (toCFMPZ b) $ \bptr -> 
                  f cptr aptr bptr

lift2FMPZ_ :: (Ptr CFMPZ -> Ptr CFMPZ -> Ptr CFMPZ -> IO a) -> FMPZ -> FMPZ -> FMPZ
lift2FMPZ_ f a b = fst $ lift2FMPZ f a b
