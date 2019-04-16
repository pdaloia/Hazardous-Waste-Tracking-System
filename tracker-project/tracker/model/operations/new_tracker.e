note
	description: "Summary description for {NEW_TRACKER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	NEW_TRACKER

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
			create phase_rad.default_create
			create container_rad.default_create
		end

feature {NONE} -- attributes

	phase_rad: VALUE
	container_rad: VALUE

feature -- command

	set_radiation(max_phase_radiation: VALUE ; max_container_radiation: VALUE)
		require
			phase_rad_not_negative: max_phase_radiation.is_greater_equal (create {VALUE}.default_create)
			container_radiation_not_negative: max_container_radiation.is_greater_equal  (create {VALUE}.default_create)
		do
			phase_rad     := max_phase_radiation
			container_rad := max_container_radiation
		ensure
			phase_rad_changed: phase_rad = max_phase_radiation
			container_rad_changed: container_rad = max_container_radiation
		end

	execute
		do
			nuclear_plant.set_message (nuclear_plant.err_success)
			nuclear_plant.set_go_to_i (" ")
			nuclear_plant.tracker.set_max_phase_radiation (phase_rad)
			nuclear_plant.tracker.set_max_container_radiation (container_rad)
		end

	undo
		do

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
