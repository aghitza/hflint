{-# LANGUAGE
    ForeignFunctionInterface
  , CApiFFI
  , EmptyDataDecls
  , FlexibleInstances
  , TypeFamilies
  #-}

module HFlint.FMPQPoly.FFI
where

#include <flint/fmpq_poly.h>

import Foreign.C.String ( CString )
import Foreign.C.Types ( CInt(..)
                       , CLong(..)
                       )
import Foreign.ForeignPtr ( ForeignPtr )
import Foreign.Ptr ( Ptr, FunPtr )
import Foreign.Storable ( Storable(..) )

import HFlint.FMPQ.FFI

#let alignment t = "%lu", (unsigned long)offsetof(struct {char x__; t (y__); }, y__)

data CFMPQPoly
newtype FMPQPoly = FMPQPoly (ForeignPtr CFMPQPoly)
data CFMPQPolyType
data FMPQPolyType = FMPQPolyType

instance Storable CFMPQPoly where
    sizeOf _ = #size fmpq
    alignment _ = #alignment fmpq
    peek = error "CFMPQPoly.peek: Not defined"
    poke = error "CFMPQPoly.poke: Not defined"


foreign import ccall unsafe "fmpq_poly_init"
        fmpq_poly_init :: Ptr CFMPQPoly -> IO ()

foreign import ccall unsafe "fmpq_poly_init2"
        fmpq_poly_init2 :: Ptr CFMPQPoly -> CLong -> IO ()

foreign import ccall unsafe "fmpq_poly_clear"
        fmpq_poly_clear :: Ptr CFMPQPoly -> IO ()

foreign import capi "flint/fmpq.h value fmpq_poly_clear"
        p_fmpq_poly_clear :: FunPtr (Ptr CFMPQPoly -> IO ())


-- foreign import capi unsafe "flint/fmpq_poly.h fmpq_poly_get_numerator"
--         fmpq_poly_get_numerator :: Ptr CFMPZPoly -> Ptr CFMPQPoly -> IO ()


foreign import capi unsafe "flint/fmpq_poly.h fmpq_poly_degree"
        fmpq_poly_degree :: Ptr CFMPQPoly -> IO CLong

foreign import ccall unsafe "fmpq_poly_set_fmpq"
        fmpq_poly_set_fmpq :: Ptr CFMPQPoly -> Ptr CFMPQ -> IO ()

-- foreign import ccall unsafe "fmpq_poly_set_fmpz_poly"
--         fmpq_poly_set_fmpz_poly :: Ptr CFMPQPoly -> Ptr CFMPZPoly -> IO ()

foreign import ccall unsafe "fmpq_poly_get_str"
        fmpq_poly_get_str :: Ptr CFMPQPoly -> IO CString

foreign import ccall unsafe "fmpq_poly_get_str_pretty"
        fmpq_poly_get_str_pretty :: Ptr CFMPQPoly -> IO CString


foreign import ccall unsafe "fmpq_poly_zero"
        fmpq_poly_zero :: Ptr CFMPQPoly -> IO ()

foreign import capi unsafe "flint/fmpq_poly.h fmpq_poly_one"
        fmpq_poly_one :: Ptr CFMPQPoly -> IO ()


foreign import ccall unsafe "fmpq_poly_neg"
        fmpq_poly_neg :: Ptr CFMPQPoly -> Ptr CFMPQPoly -> IO ()       

foreign import ccall unsafe "fmpq_poly_inv"
        fmpq_poly_inv :: Ptr CFMPQPoly -> Ptr CFMPQPoly -> IO ()       


foreign import ccall unsafe "fmpq_poly_truncate"
        fmpq_poly_truncate :: Ptr CFMPQPoly -> CLong -> IO ()       
        

foreign import ccall unsafe "fmpq_poly_get_coeff_fmpq"
        fmpq_poly_get_coeff_fmpq :: Ptr CFMPQ -> Ptr CFMPQPoly -> CLong -> IO ()

foreign import ccall unsafe "fmpq_poly_set_coeff_fmpq"
        fmpq_poly_set_coeff_fmpq :: Ptr CFMPQPoly -> Ptr CFMPQ -> CLong -> IO ()

foreign import ccall unsafe "fmpq_poly_equal"
        fmpq_poly_equal :: Ptr CFMPQPoly -> Ptr CFMPQPoly -> IO CInt

foreign import ccall unsafe "fmpq_poly_cmp"
        fmpq_poly_cmp :: Ptr CFMPQPoly -> Ptr CFMPQPoly -> IO CInt


foreign import ccall unsafe "fmpq_poly_add"
        fmpq_poly_add :: Ptr CFMPQPoly -> Ptr CFMPQPoly -> Ptr CFMPQPoly -> IO ()

foreign import ccall unsafe "fmpq_poly_sub"
        fmpq_poly_sub :: Ptr CFMPQPoly -> Ptr CFMPQPoly -> Ptr CFMPQPoly -> IO ()

foreign import ccall unsafe "fmpq_poly_scalar_mul_fmpq"
        fmpq_poly_scalar_mul_fmpq :: Ptr CFMPQPoly -> Ptr CFMPQPoly -> Ptr CFMPQ -> IO ()

foreign import ccall unsafe "fmpq_poly_scalar_div_fmpq"
        fmpq_poly_scalar_div_fmpq :: Ptr CFMPQPoly -> Ptr CFMPQPoly -> Ptr CFMPQ -> IO ()

foreign import ccall unsafe "fmpq_poly_mul"
        fmpq_poly_mul :: Ptr CFMPQPoly -> Ptr CFMPQPoly -> Ptr CFMPQPoly -> IO ()

        
foreign import ccall unsafe "fmpq_poly_shift_left"
        fmpq_poly_shift_left :: Ptr CFMPQPoly -> Ptr CFMPQPoly -> CLong -> IO ()

foreign import ccall unsafe "fmpq_poly_shift_right"
        fmpq_poly_shift_right :: Ptr CFMPQPoly -> Ptr CFMPQPoly -> CLong -> IO ()


foreign import ccall unsafe "fmpq_poly_divrem"
        fmpq_poly_divrem :: Ptr CFMPQPoly -> Ptr CFMPQPoly -> Ptr CFMPQPoly -> Ptr CFMPQPoly -> IO ()


foreign import ccall unsafe "fmpq_poly_inv_series"
        fmpq_poly_inv_series :: Ptr CFMPQPoly -> Ptr CFMPQPoly -> CLong -> IO ()

foreign import ccall unsafe "fmpq_poly_div_series"
        fmpq_poly_div_series :: Ptr CFMPQPoly -> Ptr CFMPQPoly -> Ptr CFMPQPoly -> CLong -> IO ()


foreign import ccall unsafe "fmpq_poly_gcd"
        fmpq_poly_gcd :: Ptr CFMPQPoly -> Ptr CFMPQPoly -> Ptr CFMPQPoly -> IO ()

foreign import ccall unsafe "fmpq_poly_xgcd"
        fmpq_poly_xgcd :: Ptr CFMPQPoly -> Ptr CFMPQPoly -> Ptr CFMPQPoly -> Ptr CFMPQPoly -> Ptr CFMPQPoly -> IO ()

foreign import ccall unsafe "fmpq_poly_lcm"
        fmpq_poly_lcm :: Ptr CFMPQPoly -> Ptr CFMPQPoly -> Ptr CFMPQPoly -> IO ()


foreign import ccall unsafe "fmpq_poly_make_monic"
        fmpq_poly_make_monic :: Ptr CFMPQPoly -> Ptr CFMPQPoly -> IO ()

