
BeforeAll {
    # Loading tests
    . $PSCommandPath.Replace('.Tests.ps1', '.ps1')

    . C:\workspaces\Infra-automation\sap\tests\foundation\Get-VmInfo.ps1
    }

Describe "Azure Structure Tests" {
    context "Resource Information" {
        BeforeAll {
            
        }
        it "Is Correct Resource Group" {
            
        }
        it "Is Correct Availability Zone" {
            
        }
        it "Is tagged with firewall Group" {
            
        }
    }
}

Describe "OS Tests" {
    context "Basic Configuration" {
        BeforeAll {
            $os = Get-VmInfo
        }
        it "Server name validation" {
            $os.csName | Should -Be 'OAZDK-B6RSYD3' 
        }
        it "Domain configured to vestas.net" {
            $os.csDomain | Should -Be 'WORKGROUP' 
        }
        it "TimeZone configured to Roman Time (DK, Copenhagen)" {
            $os.timeZone | Should -Be '(UTC+01:00) Brussels, Copenhagen, Madrid, Paris' 
        }
        it "Default firewall option is allow" {
            $os.domainProfileAction | Should -Be "Allow"
        }
        it "Strict Name checking is disabled" {
            
        }
    }
}

Describe "Disk Tests" {
    context "Disk Structure" {
        BeforeAll {
            
        }
        it "Drive E exists" {
            # Drive should exist
        }
        it "Drive E striped by 4" {
            4 | Should -be 4
        }
        it "Drive E formatted with blocksize 64K" {
            
        }
        it "Drive F exists" {
            # Drive should exist
        }
        it "Drive F striped by 4" {
            4 | Should -be 4
        }
        it "Drive F formatted with blocksize 64K" {
            
        }
    }
}
