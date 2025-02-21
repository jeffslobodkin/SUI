
/// Module: transcript
module transcript::transcript {
    use std::string;
	use sui::object::{Self, UID};
	use sui::transfer;
	use sui::tx_context::{Self, TxContext};
    use sui::event;
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

    public struct TeacherCap has key {
        id: UID
    }

    fun init(ctx: &mut TxContext) {
        transfer::transfer(TeacherCap {
            id: object::new(ctx)
        }, tx_context::sender(ctx))
    }

    public fun create_transcript_object(_: &TeacherCap, math: u8, science: u8, english: u8, history: u8, ctx: &mut TxContext) {
        let object = WrappableTranscript {
            id: object::new(ctx),
            math,
            science,
            english,
            history,
        };
        transfer::public_transfer(object, tx_context::sender(ctx));
    }

    public entry fun add_additional_teacher(_: &TeacherCap, new_teacher_address: address, ctx: &mut TxContext){
        transfer::transfer(
            TeacherCap {
                id: object::new(ctx)
            },
        new_teacher_address
        )
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
    public fun update_math_score(_: &TeacherCap, transcriptObject: &mut WrappableTranscript, score: u8) {
        transcriptObject.math = score;
    }

    public fun update_science_score(_: &TeacherCap, transcriptObject: &mut WrappableTranscript, score: u8) {
        transcriptObject.science = score;
    }

    public fun update_english_score(_: &TeacherCap, transcriptObject: &mut WrappableTranscript, score: u8) {
        transcriptObject.english = score;
    }

    public fun update_history_score(_: &TeacherCap, transcriptObject: &mut WrappableTranscript, score: u8) {
        transcriptObject.history = score;
    }

    //Passing the object as is means we can delete the object
    public fun delete_transcript_object(_: &TeacherCap, transcriptObject: WrappableTranscript) {
        let WrappableTranscript {id, math: _, science: _, english: _, history: _} = transcriptObject;
        object::delete(id);
    }

    public fun request_transcript(_: &TeacherCap, transcript: WrappableTranscript, intended_address: address, ctx: &mut TxContext) {
        let folderObject = Folder {
            id: object::new(ctx),
            transcript,
            intended_address
        };
        event::emit(TranscriptRequestEvent {
            wrapper_id: object::uid_to_inner(&folderObject.id),
            requester: tx_context::sender(ctx),
            intended_address
        });
        transfer::transfer(folderObject, intended_address)
    }

    public fun unpack_wrapped_transcript(_: &TeacherCap, folder: Folder, ctx: &mut TxContext) {
        assert!(folder.intended_address == tx_context::sender(ctx), 0);

        let Folder {
            id,
            transcript,
            intended_address:_,
        } = folder;

        transfer::transfer(transcript, tx_context::sender(ctx));
        object::delete(id);
    }

    //Events
    public struct TranscriptRequestEvent has copy, drop {
        wrapper_id: ID,
        requester: address,
        intended_address: address
    }

}



