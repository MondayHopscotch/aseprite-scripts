function init(plugin)
	plugin:newCommand{
		id="flixelexport",
		title="Flixel Atlas Export",
		group="file_export",
		onenabled = function()
			return app.sprite ~= nil
		end,
		onclick=function()
			-- Return the path to the dir containing a file.
			-- Source: https://stackoverflow.com/questions/9102126/lua-return-directory-path-from-path
			local Dirname = function(str)
				return str:match("(.*[/\\])")
			end

			-- Return the name of a file given its full path..
			-- Source: https://codereview.stackexchange.com/questions/90177/get-file-name-with-extension-and-get-only-extension
			local Basename = function(str)
				return str:match("^.*[/\\](.+)$") or str
			end

			-- Return the name of a file excluding the extension, this being, everything after the dot.
			-- Source: https://stackoverflow.com/questions/18884396/extracting-filename-only-with-pattern-matching
			local RemoveExtension = function(str)
				return str:match("(.+)%..+")
			end

			-- print(app.sprite)
			-- print(app.sprite.filename)

			local imgBasePath = Dirname(app.sprite.filename)

			local dataBasePath = imgBasePath
			
			if plugin.preferences.lastImagePath ~= nil then
				imgBasePath = plugin.preferences.lastImagePath
			end
			if plugin.preferences.lastDataPath ~= nil then
				dataBasePath = plugin.preferences.lastDataPath
			end

			-- print("imgBasePath: " .. imgBasePath)
			-- print("dataBasePath: " .. dataBasePath)

			local dlg = Dialog("Flixel Atlas Export")
			dlg:label{
				id="info",
				label="Helper that calls a sprite sheet export with good defaults"
			}
			dlg:label{
				id="addtl",
				label="The main export dialog will open after confirming"
			}
			dlg:separator{
				id="sep",
			}
			dlg:file{
				id="image_path",
				label="Image Export Path:",
				filename=imgBasePath .. RemoveExtension(Basename(app.sprite.filename)) .. ".png",
			}
			dlg:file{
				id="data_path",
				label="JSON Export Path:",
				filename=dataBasePath .. RemoveExtension(Basename(app.sprite.filename)) .. ".json"
			}
			dlg:button{ id="confirm", text="Confirm" }
			dlg:button{ id="cancel", text="Cancel" }
			dlg:show()

			-- print("dlg done");

			local data = dlg.data

			if not data.confirm then
				return
			end

			local texturePath = data.image_path
			local dataPath = data.data_path

			-- print("textPath: " .. texturePath)
			-- print("dataPath: " .. dataPath)

			plugin.preferences.lastImagePath = Dirname(texturePath)
			plugin.preferences.lastDataPath = Dirname(dataPath)

			app.command.ExportSpriteSheet{
				ui=false,
				askOverwrite=false,
				type=SpriteSheetType.PACKED,
				textureFilename=texturePath,
				dataFilename=dataPath,
				filenameFormat="{tag}:{frame}",
				dataFormat=SpriteSheetDataFormat.JSON_ARRAY,
				splitLayers=false,
				listLayers=layer,
				listTags=true,
				listSlices=true,
			}
		end
	}
  end
  
  function exit(plugin)

  end
  