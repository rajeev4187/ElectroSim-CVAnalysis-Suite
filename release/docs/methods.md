# Scientific Methods

The equations and conventions used by ElectroSim-DunnECASA Suite.

---

## Dunn's Method

### Mechanism classification (b-value)

For each scan rate v, the peak current i_p obeys a power law:

```
i_p(v) = a · v^b
```

Taking log₁₀ of both sides linearises the relationship:

```
log10(|i_p|) = log10(a) + b · log10(v)
```

A linear regression of `log10(|i_p|)` against `log10(v)` recovers the exponent **b** as the slope. The exponent indicates the dominant charge-storage mechanism:

| b-value | Mechanism | Typical device |
| --- | --- | --- |
| `b ≈ 1.0` | Surface-controlled (capacitive) | EDLC supercapacitor |
| `0.75 < b < 1.0` | Predominantly capacitive | Supercapacitor |
| `0.55 < b < 0.75` | Mixed capacitive / diffusion | Hybrid capacitor |
| `b ≈ 0.5` | Diffusion-controlled | Battery / pseudocapacitor |

### Current decomposition at a fixed potential

At any potential V, the total current decomposes into capacitive (scan-rate-linear) and diffusion (scan-rate-power-law) contributions:

```
i(V) = k1 · v + k2 · √v
```

Dividing both sides by √v linearises it:

```
i(V) / √v = k1 · √v + k2
```

For each potential E in a grid, the suite interpolates i(E) at every scan rate, then fits the linear equation above. The slope gives k₁ (capacitive coefficient) and the intercept gives k₂ (diffusion coefficient).

The fractional contributions are then:

```
Capacitive % = |k1·v| / |i(V)| · 100
Diffusion %  = |k2·√v| / |i(V)| · 100
```

The "decomposition" plot in the Dunn's Method tab shows i_capacitive as a shaded area underneath the total i(V) curve at the highest scan rate.

---

## ECASA — Electrochemically Active Surface Area

In the **non-Faradaic window** of a CV (a flat region with no redox features), the current arises purely from double-layer charging:

```
i = Cdl · v
```

For each scan rate v, the time-averaged |i| inside the window is half the rectangle width:

```
<|i|>_window = Cdl · v
```

A linear fit of `<|i|>_window` versus `v` across multiple scan rates yields the double-layer capacitance C_dl directly as the slope. The electrochemically active surface area is then:

```
ECASA = Cdl / Cs
```

where **Cs** is the material-class specific capacitance (a literature constant). The suite defaults to **40 µF/cm²** for carbon-based materials; adjust per material.

---

## Randles–Sevcik — Diffusion Coefficient

For a reversible redox couple at 25 °C, the peak current scales as:

```
|i_p| = 2.69 × 10^5 · n^(3/2) · A · C · D^(1/2) · v^(1/2)
```

| Symbol | Meaning | Units |
| --- | --- | --- |
| n | electrons transferred | dimensionless |
| A | electrode area | cm² |
| C | bulk concentration of redox species | mol/cm³ (the GUI accepts mmol/L and converts) |
| D | diffusion coefficient | cm²/s (the unknown) |
| v | scan rate | V/s |

A linear fit of `|i_p|` vs `√v` has slope:

```
slope = 2.69 × 10^5 · n^(3/2) · A · C · √D
```

from which:

```
D = (slope / (2.69e5 · n^(3/2) · A · C))^2
```

The intercept of the fit should be near zero; a large intercept indicates the system is not purely diffusion-controlled, and the result should be interpreted with caution.

---

## Peak detection

Peaks are detected per scan rate using `scipy.signal.find_peaks` with a prominence threshold set as a fraction of the per-scan-rate amplitude (`max(i) − min(i)`). The default fraction is **0.05** (5 %), adjustable in the Dunn's Method tab. Anodic peaks (max +i) and cathodic peaks (max −i) are detected independently; the largest peak of each polarity is reported.

For multi-peak CVs the current build reports the single dominant peak per polarity. Multi-peak handling is planned for a future release.

---

## References

1. Dunn et al., *Where Do Batteries End and Supercapacitors Begin?* Science, 2014.
2. Bard & Faulkner, *Electrochemical Methods: Fundamentals and Applications*, 2nd ed., Wiley, 2001 — Randles-Sevcik equation, Ch. 6.
3. Wang, Zhang & Zhang, *A review of electrode materials for electrochemical supercapacitors*, Chem. Soc. Rev., 41 (2012) 797.
4. Harish & Sathyakam, *Identifying Supercapacitor Charge Storage Mechanism using Dunn's Method: A Status Quo Review*, J. Energy Storage, 2025, 12481.
