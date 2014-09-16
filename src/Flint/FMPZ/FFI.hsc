{-# LANGUAGE ForeignFunctionInterface #-}

#include <flint/fmpz.h>
#include <fmpz_wrapper.h>

module Flint.FMPZ.FFI
where

import Foreign.C.String(CString)
import Foreign.C.Types(CLong(..), CInt(..))
import Foreign.Ptr(Ptr, FunPtr)
import Foreign.ForeignPtr( ForeignPtr, withForeignPtr
                         , mallocForeignPtr, addForeignPtrFinalizer )
import Control.Applicative((<$>))
import System.IO.Unsafe (unsafePerformIO)


foreign import ccall unsafe "fmpz_init_wrapper"
        fmpz_init :: Ptr CFMPZ -> IO ()

foreign import ccall unsafe "fmpz_set_si_wrapper"
        fmpz_set_si :: Ptr CFMPZ -> CLong -> IO ()

foreign import ccall unsafe "fmpz_clear_wrapper"
        fmpz_clear :: Ptr CFMPZ -> IO ()

foreign import ccall "&fmpz_clear_wrapper"
        p_fmpz_clear :: FunPtr (Ptr CFMPZ -> IO ())

foreign import ccall unsafe "fmpz_get_str"
        fmpz_get_str :: CString -> CInt -> Ptr CFMPZ -> IO CString

foreign import ccall unsafe "fmpz_sgn"
        fmpz_sgn :: Ptr CFMPZ -> IO CInt

foreign import ccall unsafe "fmpz_neg_wrapper"
        fmpz_neg :: Ptr CFMPZ -> Ptr CFMPZ -> IO ()

foreign import ccall unsafe "fmpz_abs"
        fmpz_abs :: Ptr CFMPZ -> Ptr CFMPZ -> IO ()

foreign import ccall unsafe "fmpz_add"
        fmpz_add :: Ptr CFMPZ -> Ptr CFMPZ -> Ptr CFMPZ -> IO ()

-- NOT IMPLEMENTED IN FLINT 2.4
-- foreign import ccall unsafe "fmpz_add_si"
--        fmpz_add_si :: Ptr CFMPZ -> Ptr CFMPZ -> CLong -> IO ()

foreign import ccall unsafe "fmpz_sub"
        fmpz_sub :: Ptr CFMPZ -> Ptr CFMPZ -> Ptr CFMPZ -> IO ()

foreign import ccall unsafe "fmpz_mul"
        fmpz_mul :: Ptr CFMPZ -> Ptr CFMPZ -> Ptr CFMPZ -> IO ()

foreign import ccall unsafe "fmpz_mul_si"
        fmpz_mul_si :: Ptr CFMPZ -> Ptr CFMPZ -> CLong -> IO ()

type CFMPZ = CLong
newtype FMPZ = FMPZ (ForeignPtr CFMPZ)

withFMPZ :: FMPZ -> (Ptr CFMPZ -> IO b) -> IO b
withFMPZ (FMPZ a) = withForeignPtr a

newFMPZ :: IO FMPZ
newFMPZ = do
  a <- mallocForeignPtr
  addForeignPtrFinalizer p_fmpz_clear a
  return $ FMPZ a

withNewFMPZ :: (Ptr CFMPZ -> IO a) -> (FMPZ, IO a)
withNewFMPZ f = (unsafePerformIO $ fst <$> ab, snd <$> ab)
    where
      ab = do
        a <- newFMPZ
        b <- withFMPZ a f
        return (a,b)

withNewFMPZ_ :: (Ptr CFMPZ -> IO a) -> FMPZ
withNewFMPZ_ = fst . withNewFMPZ
