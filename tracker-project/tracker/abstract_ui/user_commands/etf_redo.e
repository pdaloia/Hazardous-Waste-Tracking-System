note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_REDO
inherit
	ETF_REDO_INTERFACE
		redefine redo end
create
	make
feature -- command
	redo
    	local
		current_cursor : CURSOR
    	do
			-- perform some update on the model state
			model.default_update
			if model.history.not_last then
				model.history.forth
				model.history.item.redo
				if model.history.not_last_state then
					model.history.forth_state
					model.set_go_to_i (" (to " + model.history.item_state.item.out + ") ")
				end
				if model.history.not_last_message then
					model.history.forth_message
					model.set_message(model.history.message.item)
				end
			else
				model.set_message (model.err_e20)
				model.set_go_to_i (" ")
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
