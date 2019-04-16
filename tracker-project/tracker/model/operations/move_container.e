note
	description: "Summary description for {MOVE_CONTAINER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MOVE_CONTAINER

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
			create from_pid.make_empty
			create to_pid.make_empty
			create from_phase.make
			create to_phase.make
			create a_container.make
		end

feature {NONE} -- attributes

	cid         : STRING
	from_pid    : STRING
	to_pid      : STRING
	from_phase  : detachable PHASE
	to_phase    : detachable PHASE
	a_container : detachable PHASE_CONTAINER

feature -- command

	set_move (a_cid: STRING ; pid1: STRING ; pid2: STRING)
		require
			pid_not_same: pid1 /~ pid2
		do
			cid      := a_cid
			from_pid := pid1
			to_pid   := pid2
		ensure
		 	from_pid_changed: from_pid ~ pid1
		 	to_pid_changed: to_pid ~ pid2
		 	cid_changed: cid = a_cid
		end

	transfer_containers (a_cid: STRING ; pid1: STRING ; pid2: STRING)
		require
			pid_not_same: pid1 /~ pid2
		do
			from_phase := nuclear_plant.tracker.phases.item (pid1)
			to_phase   := nuclear_plant.tracker.phases.item (pid2)

			check attached from_phase as fp and attached to_phase as tp then
				a_container := fp.containers.at (a_cid)
				fp.containers.remove (a_cid)
				check attached a_container as ac then
					ac.set_current_phaseid (pid2)
					tp.containers.extend (ac, a_cid)
					tp.add_container_count(1)
					tp.add_phase_radiation (ac.radioactivity)
					fp.add_container_count(-1)
					fp.add_phase_radiation (-ac.radioactivity)
				end
		 	end
		ensure
			from_phase_changed: from_phase ~ nuclear_plant.tracker.phases.item (pid1)
			to_phase_changed: to_phase ~ nuclear_plant.tracker.phases.item (pid2)
		end

	execute
		do
			nuclear_plant.set_go_to_i (" ")
			nuclear_plant.set_message (nuclear_plant.err_success)
			transfer_containers(cid, from_pid, to_pid)

		end

	undo
		do
			transfer_containers(cid, to_pid, from_pid)
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

