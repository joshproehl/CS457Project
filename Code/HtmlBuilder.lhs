> {-# LANGUAGE OverloadedStrings, FlexibleInstances #-}
> module HtmlBuilder where
 
> import qualified Data.Text as D
> import HtmlStrings
> import TrimetDataTypes
 
> arrivalsMainPage :: D.Text 
> arrivalsMainPage = (htmlHead.htmlBody) (dconcat [textBox "Stop ID" "arrivalsText", htmlButton "Get Arrivals" "arrivalsButton", arrivalsJS])
 
> arrivalPageListing    :: ResultSet -> D.Text
> arrivalPageListing rs = (htmlHead.htmlBody) (dconcat [(arrivalParseResultSet rs), tableStyle])
 
> arrivalParseResultSet    :: ResultSet -> D.Text
> arrivalParseResultSet rs = dconcat ["<p>", getLocations (arrivals rs) (locations rs), "</p>"]
 
> getLocations    :: Maybe [Arrival] -> Maybe [Location] -> D.Text
> getLocations x Nothing = D.pack "There is no stop associated with this Stop ID."
> getLocations Nothing (Just ls) = dconcat [ arrivalTable (dconcat [(tableRow.tableHeader)(parseLocation l), D.pack "No arrivals within the next hour"]) | l <- ls]
> getLocations (Just as) (Just ls) = dconcat [ arrivalTable (dconcat [(tableRow.tableHeader)(parseLocation l), getArrivals (loc_locid l) as]) | l <- ls]
 
> parseLocation   :: Location -> D.Text
> parseLocation l = dconcat [ "Stop Info: ",  (D.pack.show.loc_locid) l, " ", (D.pack.loc_desc) l] 
 
> getArrivals           :: Int -> [Arrival] -> D.Text
> getArrivals stopid as = (D.pack.concat) [ "<tr><td>" ++ (parseArrival a) ++  "</td><tr>" | a <- as, stopid == arr_locid a]
 
> parseArrival :: Arrival -> String
> parseArrival a = concat ["Route: ", (show.route) a, " | Sign: ",
>                          arr_shortSign a, " | Scheduled: ",
>                          arr_scheduled a, " | Estimated: ", (getEstimate.estimated) a]
 
> getEstimate :: Maybe String -> String
> getEstimate Nothing = "none"
> getEstimate (Just x) = x
