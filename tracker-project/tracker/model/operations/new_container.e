note
	description: "Summary description for {NEW_CONTAINER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	NEW_CONTAINER

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
			create a_cid.make_empty
			create a_material.default_create
			create a_radioactivity.default_create
			create a_current_phase.make_empty
		end

feature {NONE} -- attributes

	a_cid : STRING
	a_material : INTEGER_64
	a_radioactivity : VALUE
	a_current_phase: STRING

feature -- command

	set_container(cid: STRING ; c: TUPLE[material: INTEGER_64; radioactivity: VALUE] ; pid: STRING)
		require
			rad_pos: c.radioactivity.is_greater_equal (create {VALUE}.default_create)
			cid_start_alpha_numeric: cid.at (1).is_alpha_numeric
			not_has_container: not nuclear_plant.tracker.has_container (cid)
			has_pid: nuclear_plant.tracker.phases.has (pid)
		do
			a_cid           := cid
			a_material      := c.material
			a_radioactivity := c.radioactivity
			a_current_phase := pid
		ensure
			cid_changed: a_cid ~ cid
			material_changed: a_material = c.material
			rad_changed: a_radioactivity = c.radioactivity
			pid_changed: a_current_phase ~ pid
		end

	execute
		local
			a_container : PHASE_CONTAINER
			a_phase : PHASE
			current_history_cursor : CURSOR
		do
			nuclear_plant.set_go_to_i (" ")
			nuclear_plant.set_message (nuclear_plant.err_success)

			create a_container.make
			nuclear_plant.tracker.set_tracker_in_use (true)
			a_phase := nuclear_plant.tracker.phases.item (a_current_phase)
			check attached a_phase as p then
				a_container.set_cid(a_cid)
				a_container.set_material(a_material)
				a_container.set_radioactivity(a_radioactivity)
				a_container.set_current_phaseid(a_current_phase)
				p.containers.extend (a_container, a_cid)
				p.add_container_count(1)
				p.add_phase_radiation (a_radioactivity)
			end

			-- current tracker being added to the history
			current_history_cursor := nuclear_plant.history.history.cursor
		--	nuclear_plant.history.history.put_i_th (nuclear_plant.tracker.active_tracker_op,1)
			nuclear_plant.history.history.go_to (current_history_cursor)
		end

	undo
	local
			a_phase : PHASE
			current_history_cursor : CURSOR
		do
			a_phase := nuclear_plant.tracker.phases.item (a_current_phase)
			check attached a_phase as p then
				p.containers.remove (a_cid)
				p.add_container_count(-1)
				p.add_phase_radiation (-a_radioactivity)
			end

			-- current tracker being removed from the history
			current_history_cursor := nuclear_plant.history.history.cursor
		--	nuclear_plant.history.history.prune (nuclear_plant.tracker.active_tracker_op)
			nuclear_plant.history.history.go_to (current_history_cursor)
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

