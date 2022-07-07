#Remover Usuarios AD Powershell
#Conectar ao AD
#Enter-PSSession -ComputerName hostname -Credential Domain\User_logon_name

#Argumentos
#Arg0 - 0/1 Definir se vamos utilizar lista ou unico
#Arg1 - Definir o arquivo para importar
#Arg2 - Grupo

#Modo de Uso
#Lista / Remove_Group_AD.ps1 0 group C:\Temp\lista.txt
#Unico / Remove_Group_AD.ps1 1 group User_logon_name

if ($args[0] -eq 0 )
{
    Write-Output "Removendo Usuarios de Grupo AD - Lista"
    Write-Output " "
    Write-Output "Iniciando...."
    Write-Output " "

    #carregando o arquivo
    $File = Get-Content -Path $args[2]

    #Transformando as linhas do arquivo em um array 
    $File.GetType() | Format-Table -AutoSize
    
    #Listando as linhas do arquivo
    foreach ($account in $File) 
    {
        try{
                Remove-ADGroupMember -Identity $args[1] -Members $account -Confirm:$false
                Write-Output " OK "
            }catch{
                Write-Output " NOK "
            }       
    }

}elseif ( $args[0] -eq 1){
    Write-Output "Removendo Usuarios de Grupo AD - Unico"
    Write-Output " "
    Write-Output "Iniciando...."
    Write-Output " "
    try{
        Remove-ADGroupMember -Identity $args[1] -Members $args[2] -Confirm:$false
        Write-Output " OK "
    }catch{
        Write-Output " NOK "
    }

}else{

}
