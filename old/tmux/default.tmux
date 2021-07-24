# default window layout with three splits
split-window -h -c "#{pane_current_path}"
resize-pane -R 20
split-window -v -c "#{pane_current_path}"
resize-pane -D 20
select-pane -L
