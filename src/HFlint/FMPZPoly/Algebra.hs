{-# LANGUAGE
    TemplateHaskell
  #-}

module HFlint.FMPZPoly.Algebra
where

import Prelude hiding ( (+), (-), negate, subtract
                      , (*), (/), recip, (^), (^^)
                      , gcd
                      , quotRem, quot, rem
                      )
import qualified Prelude as P

import Control.Applicative ( (<$>) )
import Control.Arrow ( second )
import qualified Data.Vector as V
import Math.Structure
import System.IO.Unsafe ( unsafePerformIO )

import HFlint.FMPZ.Internal
import HFlint.FMPZPoly.Base
import HFlint.FMPZPoly.FFI
import HFlint.FMPZPoly.Internal
import HFlint.FMPZPolyFactor
import HFlint.FMPZPolyFactor.FFI
import HFlint.Internal.Const
import HFlint.Internal.Flint


instance AdditiveMagma FMPZPoly where
  (+) = lift2Flint_ $ const fmpz_poly_add

instance Abelian FMPZPoly

instance AdditiveSemigroup FMPZPoly

instance AdditiveMonoid FMPZPoly where
  zero = lift0FlintWithType_ FMPZPolyType $ const fmpz_poly_zero

instance DecidableZero FMPZPoly where
  isZero = (/=0) . (liftFlint0 $ const fmpz_poly_is_zero)

instance AdditiveGroup FMPZPoly where
  negate = liftFlint_ $ const fmpz_poly_neg
  (-) = lift2Flint_ $ const fmpz_poly_sub


instance MultiplicativeMagma FMPZPoly where
  (*) = lift2Flint_ $ const fmpz_poly_mul

instance Commutative FMPZPoly

instance MultiplicativeSemigroup FMPZPoly

instance MultiplicativeMonoid FMPZPoly where
  one = lift0FlintWithType_ FMPZPolyType $ const fmpz_poly_one

instance DecidableOne FMPZPoly where
  isOne = (/=0) . (liftFlint0 $ const fmpz_poly_is_one)


instance Distributive FMPZPoly

instance Semiring FMPZPoly

instance Rng FMPZPoly

instance Rig FMPZPoly

instance Ring FMPZPoly

instance IntegralDomain FMPZPoly

instance FactorialRing FMPZPoly where
  factor a = unsafePerformIO $ fmap snd $
             withNewFMPZPolyFactor $ \_ pfptr -> fmap snd $
             withFMPZPoly a $ \_ aptr ->do
               fmpz_poly_factor_zassenhaus pfptr aptr
               n <- fromIntegral <$> fmpz_poly_factor_number_factors pfptr
               u <- withNewFMPZ_ $ \_ uptr ->
                    fmpz_poly_factor_get_content uptr pfptr
               f <- if n==0 then return V.empty
                    else V.generateM n $ \i -> fmap (second fromIntegral) $
                         withNewFMPZPoly $ \_ fptr ->
                         fmpz_poly_factor_get_factor fptr pfptr (fromIntegral i)
               return $ Factored (fromList [u]) f

instance PIDomain FMPZPoly where
  gcd = lift2Flint_ $ const fmpz_poly_gcd
  xgcd = lift2Flint3_ $ const3 fmpz_poly_xgcd

instance EuclideanDomain FMPZPoly where
  quotRem = lift2Flint2_ $ const2 fmpz_poly_divrem
  quot = lift2Flint_ $ const fmpz_poly_div
  rem = lift2Flint_ $ const fmpz_poly_rem
  euclNorm a | isZero a = Nothing
             | otherwise = Just $ fromIntegral $
                           (liftFlint0 $ const fmpz_poly_degree) a
