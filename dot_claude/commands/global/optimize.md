---
description: Suggest performance optimizations
---

Analyze for performance optimizations:

$ARGUMENTS

Optimization areas:
1. **Algorithmic complexity**: Better algorithms or data structures
2. **Database queries**: N+1 queries, missing indexes, inefficient joins
3. **Caching**: What can be cached? At what level?
4. **Lazy loading**: Defer expensive operations
5. **Batching**: Reduce round trips
6. **Memory usage**: Reduce allocations, prevent leaks
7. **Parallel/async**: Opportunities for concurrency

For each optimization:
- Current bottleneck
- Proposed solution
- Expected improvement
- Implementation complexity
- Trade-offs

Prioritize by impact vs. effort.
