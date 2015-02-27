{-# LANGUAGE
    FlexibleContexts
  #-}

module FMPQTests
where

import Data.Proxy
import Math.Structure.Tasty
import Test.Tasty ( testGroup , TestTree )

import HFlint.FMPQ
import FMPQTests.Rational


fmpqTestGroup :: TestTree
fmpqTestGroup = testGroup "FMPQ Tests"
                [ referenceRational
                , zeroOneUnitTests
                , testGroup "Field" $
                    isField ( Proxy :: Proxy FMPQ )
                ]
