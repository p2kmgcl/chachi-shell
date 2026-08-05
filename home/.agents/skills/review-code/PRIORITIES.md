# Priority Rubric

Classify every review finding with exactly one priority that communicates its
demonstrated consequence and realistic reachability; zero findings is a valid
review result.

**Selection.** Choose the lower priority whenever two levels remain plausible.

| Label  | Meaning                                          | Examples                                                                                                                  |
| ------ | ------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------- |
| **P0** | Blocks merge because shipping creates real harm. | Correctness failure, data loss, security vulnerability, broken invariant                                                  |
| **P1** | Merits correction before merge.                  | Logic error, broken contract, silent wrong result, likely error-path failure                                              |
| **P2** | Actionable improvement with concrete impact.     | Reachable performance regression, production blind spot, meaningful test gap, misleading contract, architectural friction |
| **P3** | Optional low-stakes suggestion.                  | Minor optimization, style preference, speculative follow-up                                                               |

**Confidence.** Match priority to demonstrated consequence and realistic
reachability. Use P3 for confident low-stakes observations and return `none`
when evidence supports no finding.
