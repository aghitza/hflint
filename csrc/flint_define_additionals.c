#include "flint_definie_additionals.h"

void
fmpz_poly_factor_get_content_additional(
  fmpz_t c,
  const fmpz_poly_factor_t fac
  )
{
  fmpz_set(c, fac->c);
}

slong
fmpz_poly_factor_number_factors_additional(
  const fmpz_poly_factor_t fac
  )
{
  return fac->num;
}

slong
fmpz_poly_factor_get_factor_additional(
  fmpz_poly_t p,
  const fmpz_poly_factor_t fac,
  slong i
  )
{
  fmpz_poly_set(p, fac->p + i);
  return fac->exp[i];
}

