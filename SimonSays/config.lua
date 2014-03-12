if ( string.sub( system.getInfo("model"), 1, 4 ) == "iPad" ) then
   application =
   {
      content =
      {
         width = 720,
         height = 960,
         scale = "letterBox",
         xAlign = "center",
         yAlign = "center",
         imageSuffix =
         {
            ["@2x"] = 1.5,
            ["@4x"] = 3.0,
         },
      },
   }
elseif ( string.sub( system.getInfo("model"), 1, 2 ) == "iP" and display.pixelHeight > 960 ) then
   application =
   {
      content =
      {
         width = 720,
         height = 1136,
         scale = "letterBox",
         xAlign = "center",
         yAlign = "center",
         imageSuffix =
         {
            ["@2x"] = 1.5,
            ["@4x"] = 3.0,
         },
      },
   }
elseif ( string.sub( system.getInfo("model"), 1, 2 ) == "iP" ) then
   application =
   {
      content =
      {
         width = 640,
         height = 960,
         scale = "letterBox",
         xAlign = "center",
         yAlign = "center",
         imageSuffix =
         {
            ["@2x"] = 1.5,
            ["@4x"] = 3.0,
         },
      },
   }
elseif ( display.pixelHeight / display.pixelWidth > 1.72 ) then
   application =
   {
      content =
      {
         width = 640,
         height = 1140,
         scale = "letterBox",
         xAlign = "center",
         yAlign = "center",
         imageSuffix =
         {
            ["@2x"] = 1.5,
            ["@4x"] = 3.0,
         },
      },
   }
 
else
   application =
   {
      content =
      {
         width = 640,
         height = 1024,
         scale = "letterBox",
         xAlign = "center",
         yAlign = "center",
         imageSuffix =
         {
            ["@2x"] = 1.5,
            ["@4x"] = 3.0,
         },
      },
   }
 
end