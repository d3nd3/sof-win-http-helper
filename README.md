# sof1 windows http helper
Put curl.exe in sof root dir.

Put http2.func in User/sofplus/addons dir.

Run the http_listener.cmd windows batch script alongside sof.

It downloads zip files from https://github.com/plowsof/sof1maps.

Extracts them and then deletes them.

If mapfile.bsp already is present in your directory, it does not download the map.