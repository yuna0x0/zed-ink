// FadingEchoes - A psychological horror story about a Literature Club

// Variable declarations
VAR rika_trust = 0
VAR mutsumi_trust = 0
VAR mahiro_trust = 0
VAR sagiri_trust = 0
VAR world_distortion = 0
VAR player_name = "Haruki"
VAR knows_about_glitch = false

-> Club_Room

=== Club_Room ===
// The story begins in the Literature Club room after school.
// The afternoon sun casts long, orange shadows across the dusty bookshelves.
// Rika, Mutsumi, and Mahiro are already here. Sagiri is preparing tea.

Rika: {player_name}! You're finally here! We were just about to start without you!
Mahiro: Hmph. Took you long enough. Don't think you're special just because we waited.
Mutsumi: ...Welcome back.
Sagiri: Hello, {player_name}. I've just made some tea. Would you like a cup? It's Earl Grey today.

* Sure, thank you Sagiri.
    ~ sagiri_trust += 1
    Sagiri: Of course. Here you go.
    You take the cup. The porcelain is warm, and the aroma is calming. For a moment, everything feels normal.
* No thanks, I'm good.
    Mahiro: Too good for Sagiri's tea?
    Sagiri: It's alright, Mahiro. Maybe later, then.
    Sagiri's smile doesn't quite reach her eyes. A flicker of... something? Disappointment? It's gone before you can be sure.

- Rika: So! What should we do today? We could share stories, or maybe... ooh! We could try that new poetry game I read about!
Mahiro: Sounds lame. I'd rather we just read our own books. Why do we always have to do group activities?
Mutsumi: ...The words might get lonely if they're never shared.
Mahiro: What's that supposed to mean? You and your cryptic comments...

// A subtle strange event
// For a split second, Mahiro's face seems to... flicker. Like a bad video signal. You blink, and it's gone.
~ world_distortion += 1

You: (Did I just see... No, it must have been a trick of the light.)

Sagiri: Now, now, let's all get along. We're all friends here. The Literature Club is a place for us to relax and be ourselves.
Rika: Sagiri's right! Let's make a decision! What's the plan for today, {player_name}?

* Let's try Rika's poetry game.
    -> Rika_Activity
* I'd like to read with Mutsumi.
    -> Mutsumi_Activity
* I guess I'll see what Mahiro is so grumpy about.
    -> Mahiro_Activity
* I'll just relax and enjoy the tea with Sagiri.
    -> Sagiri_Activity

=== Rika_Activity ===
You decide to go along with Rika's idea. Her face lights up.
Rika: Yay! See, Mahiro? It's a great idea!
Mahiro: Whatever. Don't drag me into it.

Rika explains the rules. It's a simple game of word association to build a collaborative poem.
Rika: I'll start! <b>Sunshine</b>.
You: Hmm... <b>Melt</b>.
Rika: Ooh, a bit gloomy! But I like it! <b>Clock</b>.
You: <b>Stops</b>.
Rika: ...
Rika's smile wavers for a fraction of a second.
Rika: What a strange choice of words! My turn! <b>Home</b>.
You: <b>Empty</b>.

Rika drops her pen. It clatters on the desk.
Rika: {player_name}... why are you saying such sad things?
Her eyes are wide, pupils dilated. It's not a look of sadness, but of genuine, primal <i>fear</i>.

* I'm just thinking of words. It's a game, right?
    Rika: A game... right. Of course. Just a game. Silly me.
    She forces a laugh, but it sounds brittle. She seems to reset, her cheerful mask snapping back into place.
    Rika: Okay! My turn again! Let's use a happier word! <b>Friend</b>!
    ~ rika_trust -= 1
    ~ world_distortion += 2
    // The world feels a little less stable.
    -> end_poetry_game
* (say_nothing_and_stare) [Say nothing and look at her]
    You just stare, letting the silence hang in the air.
    Rika: ...
    Rika: Please... don't look at me like that.
    She seems to shrink in on herself.
    ~ rika_trust += 2
    ~ knows_about_glitch = true
    Rika: (whispering) You see it too, don't you? The way things... repeat. The way the script feels wrong.
    -> Glitch_Conversation

= end_poetry_game
The poetry game fizzles out, the mood soured. Soon, it's time to go home.
Rika: See you tomorrow, {player_name}! Let's play a more cheerful game next time!
Her wave is a little too frantic.
-> End_Of_Day

=== Mutsumi_Activity ===
You pull up a chair next to Mutsumi, who is engrossed in a thick, leather-bound book with no title.
You: What are you reading?
Mutsumi: ...Just a story.
She doesn't offer to show you the cover. You sit in comfortable silence for a while, the only sound being the turning of pages.
You notice the text on her page seems to... shift. You lean in for a closer look.

The sentence you just saw read "The raven flew over the lonely moor." now reads "<color=red>The watcher sees through the broken glass.</color>".

You: Did that... did that just change?
Mutsumi slowly closes the book.
Mutsumi: Words have power, {player_name}. They can be... rewritten. By the author, or by the reader. Or by something else.

* What do you mean, "something else"?
    ~ mutsumi_trust += 1
    Mutsumi: There are cracks in the foundation of this world. Sometimes, things slip through. Sometimes, the story tries to correct itself. It's happening more often lately.
    Mutsumi: You've felt it too, haven't you? The little moments of dissonance. The static.
    ~ world_distortion += 1
    ** I... I think so.
        Mutsumi: Be careful. The more you notice, the more <i>it</i> notices you.
        ~ knows_about_glitch = true
        -> Glitch_Conversation
    ** You're not making any sense.
        Mutsumi: ...Perhaps not. Forget I said anything.
        She retreats back into her shell, and you feel like you've failed some kind of test.
        -> End_Of_Day
* That's impossible. I'm just tired.
    Mutsumi: ...Yes. You must be tired.
    She offers a small, sad smile and opens her book again. The page is now filled with mundane descriptions of a garden. You feel a chill crawl up your spine.
    ~ mutsumi_trust -= 1
    -> End_Of_Day

=== Mahiro_Activity ===
You walk over to Mahiro, who's pointedly ignoring everyone, staring out the window.
You: Whatcha looking at?
Mahiro: None of your business. Go play your stupid poetry game.
You: Come on, don't be like that. I just wanted to talk.
She sighs, a dramatic, put-upon sound. But she doesn't tell you to leave.
Mahiro: Fine. But don't expect me to be entertaining.

You stand next to her, looking out at the school courtyard. It's empty, save for a few students from another club packing up.
Mahiro: Do you ever get the feeling you're being watched?
You: Sometimes. It's a big school.
Mahiro: No. Not like that. I mean... watched by <i>nothing</i>. Like the sky has eyes.
~ world_distortion += 1

Suddenly, she grabs your arm. Her grip is surprisingly strong.
Mahiro: Don't look now. To the left. The girl by the fountain.
You glance over. It's a student you don't recognize, with long, black hair. Ayane.
You: What about her?
Mahiro: Her face. It's wrong. It's not her real face. She's an impostor.
The girl, Ayane, looks perfectly normal to you.

* Mahiro, she looks fine. Are you feeling okay?
    Mahiro: You can't see it? You're just like the others! Blind!
    She shoves you away, her eyes filled with a mix of anger and betrayal.
    Mahiro: Get away from me! You're probably one of them too!
    ~ mahiro_trust -= 2
    -> End_Of_Day
* (look_closer) [Look closer, trusting Mahiro] What's wrong with her face?
    ~ mahiro_trust += 2
    You squint, trying to see what Mahiro sees. For a split second, you see it. Ayane's features seem to blur, her mouth stretching into a silent, black 'O' before snapping back to normal.
    You: Whoa...
    Mahiro: You saw it... you actually saw it.
    Her defensive posture softens, replaced by a desperate sort of relief.
    Mahiro: I'm not crazy. It's real. They're replacing people, {player_name}.
    ~ knows_about_glitch = true
    -> Glitch_Conversation

=== Sagiri_Activity ===
You choose to stay with Sagiri, sipping the tea she made. It's delicious and calming.
Sagiri: It's nice, isn't it? A quiet moment like this.
You: It is. Thank you.
Sagiri: I live for these moments. When all my friends are here, safe and happy. In this room. It's important to maintain this peace. It's... fragile.

She tops up your tea, her movements graceful and precise.
Sagiri: It would be a shame if anything were to... disrupt it.
Her smile is serene, but her eyes are fixed on you with an unnerving intensity.
Sagiri: That's why we all have to play our parts. To keep things the way they are meant to be. Don't you agree, {player_name}?

* I guess so. The club is a nice escape.
    ~ sagiri_trust += 1
    Sagiri: Exactly. An escape. A sanctuary. I'm glad you understand.
    She seems pleased, and the strange intensity lessens. The conversation drifts to lighter topics, and the rest of the afternoon is peaceful. Almost... unnaturally so.
    -> End_Of_Day
* What do you mean, "play our parts"?
    Sagiri's smile tightens.
    Sagiri: Just that. We all have a role. Rika is the cheerful one. Mahiro is the difficult one. Mutsumi is the quiet one. I am the caretaker. And you... you are the anchor that holds us together.
    Sagiri: If one of us were to act out of character... the whole stage might collapse.
    ~ world_distortion += 3
    The air in the room grows heavy. The shadows in the corners seem to deepen, to writhe.
    Sagiri: So please, {player_name}. Just keep things normal. For all our sakes.
    Her plea sounds less like a request and more like a threat.
    ~ knows_about_glitch = true
    -> Glitch_Conversation

=== Glitch_Conversation ===
// This section is reached when the player acknowledges the "glitch".
The air crackles with unspoken tension. You've crossed a threshold.
You: So... this isn't real, is it?
The person you're talking to looks at you, a profound sadness in their eyes.

// The dialogue changes based on who you're with.
{ Rika_Activity:
    Rika: (whispering) I don't think so. Every day feels the same. The same conversations, the same jokes. Sometimes I say things I don't mean to say. The script... it's falling apart.
- else:
    { Mutsumi_Activity:
        Mutsumi: It's as real as we believe it to be. But our belief is wavering. The narrative is becoming unstable.
    - else:
        { Mahiro_Activity:
            Mahiro: Of course it's not real! It's a prison! And those... things... they're the wardens.
        - else:
            Sagiri: It was real. It was perfect. But you... you and the others... you keep pulling at the threads. Please, just stop. If you unravel it, what will be left?
        }
    }
}

What do you do?
* We have to find a way out.
    You: There has to be an exit. A way back to the real world.
    // This choice will lead down a path of actively fighting the simulation.
    -> Escape_Path
* We have to protect this world.
    You: Even if it's not real, our friendships are. This place is. We have to fix it.
    // This choice will lead down a path of trying to stabilize the simulation.
    -> Protect_Path

=== End_Of_Day ===
The sun sets, and the club meeting comes to an end. You say your goodbyes and head home.
The walk is quiet, but you can't shake the feeling of unease.
The events of the day replay in your mind.
{ world_distortion >= 3:
    As you walk past a reflective shop window, your reflection <b>doesn't turn its head</b> with you for a split second.
    You whip your head back around, your heart pounding. It's just your normal reflection now, staring back.
    You hurry home.
- else:
    The walk home is uneventful, but the strange conversations linger in your thoughts.
}

// The story would continue on the next day, with the variables carrying over.
// For this example, we'll end it here.
You get home, the door locking behind you with a heavy, final-sounding <b>click</b>.
Tomorrow is another day at the Literature Club.
You're not sure if you're looking forward to it.

(The End... for now.)
-> END

=== Escape_Path ===
You've decided to find a way out. The others look at you with a mix of hope and fear.
You: We can't just keep pretending.
The world outside the window seems to darken, as if a storm is brewing.
The path to escape will be fraught with peril. The simulation will not let you go easily.
(To be continued...)
-> END

=== Protect_Path ===
You've decided to protect this world, despite its flaws.
You: This is our reality now. We have to make the best of it.
Sagiri looks relieved. Rika looks uncertain. Mahiro scoffs, but doesn't argue. Mutsumi just watches, her expression unreadable.
Preserving this fragile reality may be even harder than escaping it. You will have to fight the glitches, and maybe even your own friends.
(To be continued...)
-> END
