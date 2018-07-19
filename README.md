## Notes
- My solutions probably aren't the best.
- For problem 8 you could probably use a chunk size of 2 with slight modifications.
- For problem 14 I don't think there is a solution other than just brute forcing it. I couldn't figure out a way to make [this](https://math.stackexchange.com/questions/636128/calculating-the-number-of-possible-paths-through-some-squares) work with the blocks you can't travel to.
- Problem 17's Roman numeral decoder isn't perfect. For example it accepts something like MIXVI, which is invalid. But, it works within codewars' specs.
- Problem 20 could be done differently, but I wanted to save time, so I copied some code from [d-astar](https://github.com/d-astar).
- Problem 22 adopted from 2017 codewars solutions. Was not a fun problem.
- Currently there are only Problems 1-22. 23, and 24 will be added later.
## Building
Building is simple. Just `dub build --config=<problem>` with any other compile options you want.