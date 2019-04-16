note
	description: "Summary description for {REMOVE_PHASE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	REMOVE_PHASE

inherit
	OPERATION
		redefine
			out
		end
	DEBUG_OUTPUT
		redefine
			out
		end

create
	make

feature {NONE}

	make
		do
			stored_message := " "
			create phaseid.make_empty
		end

feature {NONE} -- attributes

	phaseid          : STRING
	remove_phase: detachable PHASE

feature -- command

	set_remove (a_phaseid: STRING)
		require nuclear_plant.tracker.phases.has (a_phaseid)
		do
			phaseid := a_phaseid
		ensure
			phase_id_changed: phaseid ~ a_phaseid
		end

	execute
		do
			nuclear_plant.set_go_to_i (" ")
			nuclear_plant.set_message (nuclear_plant.err_success)
			remove_phase := nuclear_plant.tracker.phases.at (phaseid)
			nuclear_plant.tracker.phases.remove (phaseid)
		end

	undo
		do
			check attached remove_phase as rp then
				nuclear_plant.tracker.phases.extend (rp, phaseid)
			end
		end
	redo
		do
			execute
		end

feature

	out: STRING
		do
			Result := stored_message
		end

	debug_output: STRING
		do
			Result := out
		end


end
