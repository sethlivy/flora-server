module FloraWeb.Pages.Templates.Screens.Search where

import Control.Monad (when)
import Data.Positive
import Data.Text (Text)
import Data.Text.Display (display)
import Data.Vector (Vector)
import Lucid

import Flora.Model.Package (Namespace, PackageInfo (..))
import Flora.Search (SearchAction (..))
import FloraWeb.Components.PackageListHeader (presentationHeader)
import FloraWeb.Components.PaginationNav (paginationNav)
import FloraWeb.Pages.Templates
import FloraWeb.Pages.Templates.Packages (packageListing)

showAllPackages :: Word -> Positive Word -> Vector PackageInfo -> FloraHTML
showAllPackages count currentPage packagesInfo = do
  div_ [class_ "container"] $ do
    presentationHeader "Packages" "" count
    div_ [class_ ""] $ packageListing Nothing packagesInfo
    paginationNav count currentPage ListAllPackages

showAllPackagesInNamespace :: Namespace -> Word -> Positive Word -> Vector PackageInfo -> FloraHTML
showAllPackagesInNamespace namespace count currentPage packagesInfo = do
  div_ [class_ "container"] $ do
    presentationHeader (display namespace) "" count
    div_ [class_ ""] $ packageListing Nothing packagesInfo
    paginationNav count currentPage (ListAllPackagesInNamespace namespace)

showResults
  :: Text
  -> Word
  -> Positive Word
  -> Vector PackageInfo
  -- ^ Exact matches
  -> Vector PackageInfo
  -- ^ Results
  -> FloraHTML
showResults searchString count currentPage exactMatches results = do
  div_ [class_ "container"] $ do
    presentationHeader searchString "" count
    packageListing (Just exactMatches) results
    when (count > 30) $
      paginationNav count currentPage (SearchPackages searchString)