note
	description: "Summary description for {NEW_PHASE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	NEW_PHASE

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
			create a_phaseid.make_empty
			create a_name.make_empty
			create a_capacity.default_create
			create a_materials.make_empty
		end

feature {NONE} -- attributes

	a_phaseid: STRING
	a_name: STRING
	a_capacity: INTEGER_64
	a_materials: ARRAY[INTEGER_64]

feature -- command

	set_phase(pid: STRING ; phase_name: STRING ; capacity: INTEGER_64 ; expected_materials: ARRAY[INTEGER_64])
		require
			alpha_numeric_vals: pid.at (1).is_alpha_numeric and phase_name.at (1).is_alpha_numeric
			not_contained: not nuclear_plant.tracker.phases.has (pid)
			capacity_above_zero: capacity > 0
			mat_not_empty: not expected_materials.is_empty
		do
			a_phaseid   := pid
			a_name      := phase_name
			a_capacity  := capacity
			a_materials := expected_materials
		ensure
			pid_changed: a_phaseid ~ pid
			name_changed: a_name ~ phase_name
			cap_changed: a_capacity = capacity
			mat_changed: a_materials ~ expected_materials
		end

	execute
		local
			a_phase : PHASE
		do
			nuclear_plant.set_go_to_i (" ")
			nuclear_plant.set_message (nuclear_plant.err_success)

			create a_phase.make
			a_phase.set_phaseid(a_phaseid)
			a_phase.set_name(a_name)
			a_phase.set_capacity(a_capacity)
			a_phase.material_switch(a_materials)
			nuclear_plant.tracker.phases.extend(a_phase,a_phaseid)
		end

	undo
		do
			nuclear_plant.tracker.phases.remove (a_phaseid)
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

