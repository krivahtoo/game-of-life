# Conway's Game of Life
Writen in lua using love2D framework

## Screeshot
![2021-12-01-214219_506x302_scrot](https://user-images.githubusercontent.com/41364823/144294781-c0fe3538-7443-453d-8ae2-baad9665f49f.png)


## Rules
- Any live cell with fewer than two live neighbours dies, as if by underpopulation.
- Any live cell with two or three live neighbours lives on to the next generation.
- Any live cell with more than three live neighbours dies, as if by overpopulation.
- Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.

See [https://en.wikipedia.org/wiki/Conway's_Game_of_Life](https://en.wikipedia.org/wiki/Conway's_Game_of_Life)

## Quick start

Install [LÖVE](https://love2d.org/#download) and run

```shell
git clone https://github.com/krivahtoo/game-of-life.git
love game-of-life
```
