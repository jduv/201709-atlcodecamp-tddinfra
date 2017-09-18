describe npm('express') do
    it { should be_installed }
end

describe port(3000) do
    it { should be_listening }
    its('processes') { should include 'node' }
end

describe bash('ls /tmp/app') do
    its('exit_status') { should eq 0 }
end