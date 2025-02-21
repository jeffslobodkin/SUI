
/// Module: transcript
module transcript::transcript {
    use std::string;
	use sui::object::{Self, UID};
	use sui::transfer;
	use sui::tx_context::{Self, TxContext};

    //Create a folder to store the transcript objects
    public struct Folder has key {
        id: UID,
        transcript: WrappableTranscript,
        intended_address: address
    }

    public struct WrappableTranscript has key, store {
        id: UID,
        math: u8,
        science: u8,
        english: u8,
        history: u8,
    }

    public fun create_transcript_object(math: u8, science: u8, english: u8, history: u8, ctx: &mut TxContext) {
        let object = WrappableTranscript {
            id: object::new(ctx),
            math,
            science,
            english,
            history,
        };
        transfer::public_transfer(object, tx_context::sender(ctx));
    }


    //Passinjg objecvt as reference means we are not taking ownership of the object and we can only read the object
    public fun get_math_score(transcriptObject: &WrappableTranscript): u8 {
        transcriptObject.math
    }

    public fun get_science_score(transcriptObject: &WrappableTranscript): u8 {
        transcriptObject.science
    }

    public fun get_english_score(transcriptObject: &WrappableTranscript): u8 {
        transcriptObject.english
    }

    public fun get_history_score(transcriptObject: &WrappableTranscript): u8 {
        transcriptObject.history
    }

    //Passing object with mut means we are taking ownership of the object and we can modify the object but we cant delete the object
    public fun update_math_score(transcriptObject: &mut WrappableTranscript, score: u8) {
        transcriptObject.math = score;
    }

    public fun update_science_score(transcriptObject: &mut WrappableTranscript, score: u8) {
        transcriptObject.science = score;
    }

    public fun update_english_score(transcriptObject: &mut WrappableTranscript, score: u8) {
        transcriptObject.english = score;
    }

    public fun update_history_score(transcriptObject: &mut WrappableTranscript, score: u8) {
        transcriptObject.history = score;
    }

    //Passing the object as is means we can delete the object
    public fun delete_transcript_object(transcriptObject: WrappableTranscript) {
        let WrappableTranscript {id, math: _, science: _, english: _, history: _} = transcriptObject;
        object::delete(id);
    }



    public fun request_transcript(transcript: WrappableTranscript, intended_address: address, ctx: &mut TxContext) {
        let folderObject = Folder {
            id: object::new(ctx),
            transcript,
            intended_address
        };
        transfer::transfer(folderObject, intended_address)
    }

    public fun unpack_wrapped_transcript(folder: Folder, ctx: &mut TxContext) {
        assert!(folder.intended_address == tx_context::sender(ctx), 0);

        let Folder {
            id,
            transcript,
            intended_address:_,
        } = folder;

        transfer::transfer(transcript, tx_context::sender(ctx));
        object::delete(id);
    }



}



