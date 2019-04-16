note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_UNDO
inherit
	ETF_UNDO_INTERFACE
		redefine undo end
create
	make
feature -- command
	undo
	local
		current_cursor : CURSOR
    	do
			-- perform some update on the model state
			model.default_update
			if model.history.on_item then
				model.history.item.undo
				model.history.back
				if model.history.on_message_item then
						model.history.back_message
						model.set_message (model.history.item_message)
				end
				if model.history.on_state_item then
						model.history.back_state
						model.set_go_to_i (" (to " + model.history.item_state.item.out + ") ")
				end
			else
				model.set_message (model.err_e19)
				model.set_go_to_i (" ")
			end
		--	model.increment_old_i
			etf_cmd_container.on_change.notify ([Current])
    	end

end
