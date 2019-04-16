note
	description: "Summary description for {MESSAGE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MESSAGE
inherit
	OPERATION
create
	make

feature {NONE}
	make(a_message: STRING)
		do
			old_message := nuclear_plant.message
			stored_message := a_message
		end

feature {NONE} -- attr
old_message: STRING

feature -- commands
	execute
		require else
			message_not_void: stored_message /~ void
		do
			nuclear_plant.set_message (stored_message)
			nuclear_plant.set_go_to_i (" ")
		ensure then
			message_changed: nuclear_plant.message ~ stored_message
		end

	undo
		do
		--	nuclear_plant.set_message (old_message)
		end

	redo
		do
		--	execute
		end
end
