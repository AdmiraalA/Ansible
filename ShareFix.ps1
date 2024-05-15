# Definieer het pad van de netwerkshare
$netwerkSharePad = "H:\"

# Voeg de netwerkshare toe aan de uitsluitingen
Add-MpPreference -ExclusionPath $netwerkSharePad
