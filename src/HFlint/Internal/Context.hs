{-# LANGUAGE
    ConstraintKinds
  , FlexibleContexts
  , FlexibleInstances
  , RankNTypes
  , MultiParamTypeClasses
  , TypeFamilies
  #-}

module HFlint.Internal.Context
  ( FlintContext(..)
  , ReifiesFlintContext
  )
where

import Data.Proxy
import Data.Reflection
import Foreign.Ptr ( Ptr )

type ReifiesFlintContext ctx ctxProxy =
  ( FlintContext ctx, Reifies ctxProxy (Ptr (CFlintCtx ctx)) )

class FlintContext ctx where
  data CFlintCtx ctx :: *
  data FlintContextData ctx :: *

  newFlintContext
    :: FlintContextData ctx
    -> IO ctx

  withFlintContext
    :: ctx
    -> (    forall ctxProxy .
            ReifiesFlintContext ctx ctxProxy
         => Proxy ctxProxy -> b)
    -> b
