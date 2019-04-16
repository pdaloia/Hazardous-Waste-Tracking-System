note
	description: "Summary description for {REMOVE_CONTAINER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	REMOVE_CONTAINER

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
			stored_message := ""
			create cid.make_empty
			create phaseid.make_empty
			create remove_from_phase.make
			create remove_container.make
		end

feature {NONE} -- attributes

	cid              : STRING
	phaseid          : STRING
	remove_from_phase: detachable PHASE
	remove_container : detachable PHASE_CONTAINER

feature -- command

	set_remove (a_cid: STRING)
		require
			nuclear_plant.tracker.has_container (a_cid)
		do
			cid := a_cid
			phaseid := nuclear_plant.tracker.get_current_phaseid(cid)
		ensure
			cid_changed: cid ~ a_cid
			phase_id_changed: phaseid ~ nuclear_plant.tracker.get_current_phaseid(cid)
		end

	execute
		do
			nuclear_plant.set_go_to_i (" ")
			nuclear_plant.set_message (nuclear_plant.err_success)
			remove_from_phase := nuclear_plant.tracker.phases.at (phaseid)
			check attached remove_from_phase as rfp then
				remove_container := rfp.containers.at(cid)
				rfp.containers.remove (cid)
				check attached remove_container as rc then
					rfp.add_container_count(-1)
					rfp.add_phase_radiation (-rc.radioactivity)
				end
			end
		end

	undo
		do
			nuclear_plant.set_go_to_i (" ")
			remove_from_phase := nuclear_plant.tracker.phases.at (phaseid)
			check attached remove_from_phase as rfp then
				check attached remove_container as rc then
					rfp.containers.extend (rc, cid)
					rfp.add_container_count(1)
					rfp.add_phase_radiation (rc.radioactivity)
				end
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

