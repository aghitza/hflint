{-# LANGUAGE
    FlexibleInstances
  , GeneralizedNewtypeDeriving
  , StandaloneDeriving
  , TemplateHaskell
  #-}

module HFlint.FMPQ.Algebra
where

import Prelude hiding ( (+), (-), negate, subtract
                      , (*), (/), recip, (^), (^^)
                      , gcd
                      , quotRem, quot, rem
                      )
-- import qualified Prelude as P

import Math.Structure.Additive
import Math.Structure.Instances.TH.Additive
import Math.Structure.Instances.TH.Multiplicative
import Math.Structure.Instances.TH.Ring

import HFlint.FMPQ.Arithmetic ()
import HFlint.FMPQ.FFI

mkAbelianGroupInstanceFromNum (return []) [t|FMPQ|]
mkCommutativeGroupInstanceFromNonZeroFractional (return []) [t|FMPQ|]
mkFieldInstance (return []) [t|FMPQ|]
