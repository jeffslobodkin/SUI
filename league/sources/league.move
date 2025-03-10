
/// Module: league
module league::league;

use std::string;

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
	referee:ID

}

public struct AdminRole has key, store {
    id: UID,
}

fun init(ctx: &mut TxContext) {
	let admin = AdminRole {
		id: object::new(ctx),
	};
	transfer::public_transfer(
		create_league(&admin, string::utf8(b"League1"), ctx)
		, tx_context::sender(ctx));
    transfer::transfer(admin, tx_context::sender(ctx));
}

public fun create_league(_: &AdminRole, name: string::String, ctx: &mut TxContext): League
{
	 League {
		id : object::new(ctx),
		players: vector::empty<UID>(),
		name,
	}

}

public fun create_player(name: string::String, ctx: &mut TxContext): Player {
	 Player {
		id: object::new(ctx),
		name:name,
	}
}
