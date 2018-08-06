
# Dataset Directory
$datasetDirectory = 'C:\Users\Darren Robinson\Powershell\Dataset\Generate-Random-Users'
# Female Firstnames 
$femaleFirstnames = "firstnames-femalecy2017top.csv"
# Male Firstnames 
$MaleFirstnames = "firstnames-malecy2017top.csv"
# Surnames
$surnamesList = "Surnames.csv"
# Postcodes
$postCodesList = "australian_postcodes.csv"
# Streetnames
$streetNamesList = "streetnames.csv"

# Female Firstnames
if ("$($datasetDirectory)\$($femaleFirstnames)") {
  $fFirstNames = Import-Csv -Delimiter "," -Path "$($datasetDirectory)\$($femaleFirstnames)" | foreach {     
    New-Object PSObject -prop @{
      GivenName = (Get-Culture).textinfo.totitlecase($_.'Given Name'.tolower());
    }
  }
}

# Male Firstnames
if ("$($datasetDirectory)\$($maleFirstnames)") {
  $mFirstNames = Import-Csv -Delimiter "," -Path "$($datasetDirectory)\$($maleFirstnames)" | foreach {     
    New-Object PSObject -prop @{
      GivenName = (Get-Culture).textinfo.totitlecase($_.'Given Name'.tolower());
    }
  }
}

# Combine Male and Female firstnames
$firstnames = $mFirstNames + $fFirstNames

# Surnames
if ("$($datasetDirectory)\$($surnamesList)") {
  $surnames = Import-Csv -Delimiter "," -Path "$($datasetDirectory)\$($surnamesList)" | foreach {     
    New-Object PSObject -prop @{
      Surname = (Get-Culture).textinfo.totitlecase($_.'Surnames'.tolower());
    }
  }
}

# PostCodes
if ("$($datasetDirectory)\$($postcodesList)") {
  $postcodes = Import-Csv -Delimiter "," -Path "$($datasetDirectory)\$($postcodesList)" | foreach {     
    New-Object PSObject -prop @{
      Postcode = $_.'postcode';
      Suburb = $_.'locality';
      State = $_.'state';
    }
  }
}

# Street Names List
if ("$($datasetDirectory)\$($streetnamesList)") {
  $streetnames = Import-Csv -Delimiter "," -Path "$($datasetDirectory)\$($streetnamesList)" | foreach {     
    New-Object PSObject -prop @{
      Streetname = (Get-Culture).textinfo.totitlecase($_.'STREET_NAME'.tolower());        
    }
  }
}

# Generate JSON object for 100 users
1..100 | foreach {
  $randGivenName = Get-Random $firstnames.Count
  $randSurname = Get-Random $surnames.Count
  $randPostcode = Get-Random $postcodes.Count
  $randStreet = Get-Random $streetnames.Count

  $givenName = $firstnames[$randGivenName].GivenName
  $surname = $surnames[$randSurname].Surname
  $street = $streetnames[$randStreet].Streetname
  $postcode = $postcodes[$randPostcode].Postcode
  $suburb = $postcodes[$randPostcode].Suburb
  $state = $postcodes[$randPostcode].State
  $streetNumber = (Get-Random -Minimum 1 -Maximum 1000)

  $body = @{
      GivenName = $givenName
      Surname = $surname
      Street = "$([string]$streetNumber) $($street)" 
      Postcode = $postcode
      Suburb = $suburb
      State = $state     
    }
  $body = $body | ConvertTo-Json
  $body

  # API Call to create user here
  # Create user
}

