{-# LANGUAGE
    TypeFamilies
  , MultiParamTypeClasses
  , FunctionalDependencies
  #-}

module HFlint.Internal.FlintWithContext
  ( FlintWithContext(..)
  )
where

import Foreign.Ptr ( Ptr )

import HFlint.Internal.Context


-- class of Flint types that do not require a context
class FlintContext ctx => FlintWithContext ctx a | a -> ctx where
  data CFlint a :: *


  newFlintCtx :: RIOFlint ctx a


  withFlintCtx
    :: a
    -> (Ptr (CFlint a) -> Ptr (CFlintCtx ctx) -> IO b)
    -> RIOFlint ctx (a, b)

  {-# INLINE withFlintImplicitCtx #-}
  withFlintImplicitCtx
    :: a -> (Ptr (CFlint a) -> RIOFlint ctx b)
    -> RIOFlint ctx (a,b)
  withFlintImplicitCtx a f = withFlintCtx a $ implicitCtx f


  {-# INLINE withNewFlintCtx #-}
  withNewFlintCtx
    :: (Ptr (CFlint a) -> Ptr (CFlintCtx ctx) -> IO b)
    -> RIOFlint ctx (a, b)
  withNewFlintCtx f = flip withFlintCtx f =<< newFlintCtx

  {-# INLINE withNewFlintImplicitCtx #-}
  withNewFlintImplicitCtx
    :: ( Ptr (CFlint a) -> RIOFlint ctx b)
    -> RIOFlint ctx (a, b)
  withNewFlintImplicitCtx f = withNewFlintCtx $ implicitCtx f


  {-# INLINE withFlintCtx_ #-}
  withFlintCtx_
    :: a
    -> (Ptr (CFlint a) -> Ptr (CFlintCtx ctx) -> IO b)
    -> RIOFlint ctx a
  withFlintCtx_ a f = fst <$> withFlintCtx a f

  {-# INLINE withFlintImplicitCtx_ #-}
  withFlintImplicitCtx_
    :: a
    -> ( Ptr (CFlint a) -> RIOFlint ctx b )
    -> RIOFlint ctx a
  withFlintImplicitCtx_ a f = fst <$> withFlintImplicitCtx a f


  {-# INLINE withNewFlintCtx_ #-}
  withNewFlintCtx_
    :: (Ptr (CFlint a) -> Ptr (CFlintCtx ctx) -> IO b)
    -> RIOFlint ctx a
  withNewFlintCtx_ f = fst <$> withNewFlintCtx f

  {-# INLINE withNewFlintImplicitCtx_ #-}
  withNewFlintImplicitCtx_
    :: ( Ptr (CFlint a) -> RIOFlint ctx b )
    -> RIOFlint ctx a
  withNewFlintImplicitCtx_ f = fst <$> withNewFlintImplicitCtx f
