
/// Module: league
module league::league;

use std::string;
use sui::object::{Self, UID};
use sui::transfer;
use sui::tx_context::{Self, TxContext};
use std::vector;
use std::ascii;

public struct League has key, store{
	id:UID,
	players: vector<UID>,
	name: string::String,
}

public struct Player has key, store{
	id:UID,
	name: string::String,
}

public struct Game has key, store{
	id:UID,
	referee:UID

}

public struct AdminRole has key, store {
    id: UID,
}

fun init(ctx: &mut TxContext) {
	let admin = AdminRole {
		id: object::new(ctx),
	};
	create_league(&admin, ctx, string::from_ascii(ascii::string(b"League1")));

    transfer::transfer(admin, tx_context::sender(ctx));
}

public fun create_league(_: &AdminRole, ctx: &mut TxContext, name: string::String)
{
	let this_league = League {
		id : object::new(ctx),
		players: vector::empty<UID>(),
		name,
	};

	transfer::public_transfer(this_league, tx_context::sender(ctx));
}

public fun create_player(ctx: &mut TxContext, name: string::String) {
	let player = Player {
		id: object::new(ctx),
		name,
	};
	transfer::public_transfer(player, tx_context::sender(ctx));
}
public fun make_work(ctx: &mut TxContext, number: u64)
{
	create_player(ctx, string::from_ascii(ascii::string(b"Player One")));
}

public fun make_work_now(ctx: &mut TxContext)
{
	create_player(ctx, string::from_ascii(ascii::string(b"Player One")));
}
