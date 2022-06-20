#Script para bloqueio/desbloqueio de usuarios O365 PowerShell
#Autores: Izael Magalhaes / Jhonatan Teodoro / Yuri Alves
#Modo de uso: script.ps1 arg0 arg1 arg2
#arg0:bloqueio ou desbloqueio (0 - bloqueio/ 1 - Desbloqueio)
#arg1:se é lista ou individual (0 - unico / 1 - lista)
#arg2: lista ou usuario individual ( email@ex.com / C://temp/users.txt) *** A lista precisa ser txt
#
#Login O365
#Connect-msolservice
#Connect-azuread
#Connect-ExchangeOnline
#
#Desbloqueio
#script.ps1 1 1 C:\temp\users.txt
#script.ps1 1 0 example@ex.com
#
#Desbloqueio
#script.ps1 0 1 C:\temp\users.txt
#script.ps1 0 0 example@ex.com
#
Write-Output " "
Write-Output "Iniciando Script...."
Write-Output " "
#validar se é bloqueio ou desbloqueio
if ( $args[0] -eq 0 )
{
    Write-Output "Modo Selecionado: Bloqueio"
    Write-Output " "
    Write-Output "Executando Scripts...."
    Write-Output " "

    #Validar se é Individual ou Lista
    if ( $args[1] -eq 0 )
    {    
        Write-Output "Modo Selecionado: Individual"

        Write-Output " "

        Write-Output "========================================"
        Write-Output ""
        Write-Output "Bloqueando $args[2]"
        Write-Output ""
        
        #Outlook
        try{
            Set-CASMailbox $args[2] -OWAEnabled $false -PopEnabled $false -SmtpClientAuthenticationDisabled $true -OutlookMobileEnabled $false;
            Write-Output " Outlook OK "
        }
        catch{
            Write-Output " Outlook NOK "
        }
        
        #Teams
        $LO = New-MsolLicenseOptions -AccountSkuId "reseller-account:STANDARDPACK" -DisabledPlans "TEAMS1"

        try{        
            Set-MsolUserLicense -UserPrincipalName $args[2] -LicenseOptions $LO
            Write-Output " Teams OK "
        }
        catch{
            Write-Output "Teams NOK "
        }
        
        Write-Output " "
        Write-Output "========================================"    
    }elseif ( $args[1] -eq 1){
        Write-Output "Modo Selecionado: Lista"

        Write-Output " "
        
        #carregando o arquivo
        $File = Get-Content -Path $args[2]

        #Transformando as linhas do arquivo em um array 
        $File.GetType() | Format-Table -AutoSize

        #Listando as linhas do arquivo
        foreach ($email in $File) 
        {
            Write-Output "========================================"
            Write-Output ""
            Write-Output "Bloqueando $email"
            Write-Output ""
        
            #Outlook
            try{
                Set-CASMailbox $email -OWAEnabled $false -PopEnabled $false -SmtpClientAuthenticationDisabled $true -OutlookMobileEnabled $false;
                Write-Output " Outlook OK "
            }
            catch{
                Write-Output " Outlook NOK "
            }
        
            #Teams
            $LO = New-MsolLicenseOptions -AccountSkuId "reseller-account:STANDARDPACK" -DisabledPlans "TEAMS1"

            try{        
                Set-MsolUserLicense -UserPrincipalName $email -LicenseOptions $LO
                Write-Output " Teams OK "
            }
            catch{
                Write-Output "Teams NOK "
            }
        }
        
        Write-Output " "
        Write-Output "========================================"    
    }else{
        Write-Output "Erro -> Veja o modo de Uso"
    }
        
}elseif ( $args[0] -eq 1){
    
    Write-Output "Modo Selecionado: Desbloqueio"
    Write-Output " "
    Write-Output "Executando Scripts...."
    Write-Output " "


    #Validar se é Individual ou Lista
    if ( $args[1] -eq 0 )
    {    
        Write-Output "Modo Selecionado: Individual"

        Write-Output " "

        Write-Output "========================================"
        Write-Output ""
        Write-Output "Desbloqueando $email"
        Write-Output ""

        #Outlook
        try{
            Set-CASMailbox $args[2] -OWAEnabled $true -PopEnabled $true -SmtpClientAuthenticationDisabled $false -OutlookMobileEnabled $true;
            Write-Output "Outlook OK"
        }
        catch{
            Write-Output "Outlook NOK"
            }

        #Teams
        try{
            $LE = New-MsolLicenseOptions -AccountSkuId "reseller-account:STANDARDPACK"
            Set-MsolUserLicense -UserPrincipalName $args[2] -LicenseOptions $LE
            Write-Output "Teams OK"
        }
        catch{
            Write-Output "Teams NOK"
            }
    
    }elseif ( $args[1] -eq 1){
        Write-Output "Modo Selecionado: Lista"
        Write-Output " "

        #carregando o arquivo
        $File = Get-Content -Path $args[2]

        #Transformando as linhas do arquivo em um array 
        $File.GetType() | Format-Table -AutoSize

        #Listando as linhas do arquivo
        foreach ($email in $File) 
        { 
            Write-Output "========================================"
            Write-Output ""
            Write-Output "Desbloqueando $email"
            Write-Output ""

            #Outlook
            try{
                Set-CASMailbox $email -OWAEnabled $true -PopEnabled $true -SmtpClientAuthenticationDisabled $false -OutlookMobileEnabled $true;
                Write-Output "Outlook OK"
            }
            catch{
                
                Write-Output "Outlook NOK"
            }


            #capturando a licença
            $LE = New-MsolLicenseOptions -AccountSkuId "reseller-account:STANDARDPACK"
        
            #Teams
            try{
                
               Set-MsolUserLicense -UserPrincipalName $email -LicenseOptions $LE
                
                Write-Output "Teams OK"
           }
           catch{
                    Write-Output "Teams NOK"
                }

            Write-Output " "
            Write-Output "========================================"
        }
    }else{
        Write-Output "Erro -> Veja o modo de Uso"
    }
}else{
    Write-Output "Erro -> Veja o Modo de Uso"
}

Write-Output " "
Write-Output "Script Concluido - By Izael Magalhaes"

Write-Output ""
