#[system]
mod move {
    use dojo::world::Context;

    use dojo_gameoflife::components::Position;
    use dojo_gameoflife::components::Moves;

    #[event]
    use dojo_gameoflife::events::{Event, Moved};

    #[derive(Serde, Drop)]
    enum Direction {
        Left: (),
        Right: (),
        Up: (),
        Down: (),
    }

    impl DirectionIntoFelt252 of Into<Direction, felt252> {
        fn into(self: Direction) -> felt252 {
            match self {
                Direction::Left(()) => 0,
                Direction::Right(()) => 1,
                Direction::Up(()) => 2,
                Direction::Down(()) => 3,
            }
        }
    }

    fn execute(ctx: Context, direction: Direction) {
        let (mut position, mut moves) = get!(ctx.world, ctx.origin, (Position, Moves));
        moves.remaining -= 1;
        let next = next_position(position, direction);
        set!(ctx.world, (moves, next));
        emit!(ctx.world, Moved { player: ctx.origin, x: next.x, y: next.y, });
        return ();
    }

    fn next_position(mut position: Position, direction: Direction) -> Position {
        match direction {
            Direction::Left(()) => {
                position.x -= 1;
            },
            Direction::Right(()) => {
                position.x += 1;
            },
            Direction::Up(()) => {
                position.y -= 1;
            },
            Direction::Down(()) => {
                position.y += 1;
            },
        };

        position
    }
}

