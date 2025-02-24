
/// Module: league
module league::league;

use std::string;
	use sui::object::{Self, UID};
	use sui::transfer;
	use sui::tx_context::{Self, TxContext};
	use std::vector;

// For Move coding conventions, see
// https://docs.sui.io/concepts/sui-move-concepts/conventions

public struct League has key, store{
	id:UID,
	players: vector<UID>,
	name: string,
}

public struct Player has key, store{
	id:UID,
}

public struct Game has key, store{
	id:UID,
	referee:UID

}

public struct AdminRole has key, store {
    id: UID,
    leagues:vector<UID>
}

fun init(ctx: &mut TxContext) {
    transfer::transfer(AdminRole {
        id: object::new(ctx)
    }, tx_context::sender(ctx))

}

public fun entry create_league(_: &AdminRole, ctx: &mut TxContext, name: string): League
{
	let this_league = League {
		id : object::new(ctx),
		players: vector::empty<UID>(),
		name,
	};

	transfer::public_tranfer<League>(this_league, ctx::sender);

}

// public fun entry create_game(_: &AdminRole, ctx: &mut TxContext)
// {
// 	let this_game = Game {
// 		id : object::new(ctx),
// 		referee
// 	}

// }

// public fun entry create_player(ctx: &mut TxContext)
// {

// }

