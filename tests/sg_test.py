import boto3
import unittest
import json
import botocore

bucketName = '7factor.io'
statefile = open('../terraform.tfstate.backup')
tfstate = json.load(statefile)

class SecurityGroupTests(unittest.TestCase):
    def setUp(self):
        self.ec2 = boto3.resource('ec2')

    def test_nodeSgOpensTheCorrectPorts(self):
        sgId = tfstate['modules'][0]['resources']['aws_security_group.node_access']['primary']['id']
        sg = self.ec2.SecurityGroup(sgId)
        self.assertEqual(sg.ip_permissions[0]['FromPort'], 3000)
        self.assertEqual(sg.ip_permissions[0]['ToPort'], 3000)

    def test_sshSgOpensTheCorrectPorts(self):
        sgId = tfstate['modules'][0]['resources']['aws_security_group.ssh_access']['primary']['id']
        sg = self.ec2.SecurityGroup(sgId)
        self.assertEqual(sg.ip_permissions[0]['FromPort'], 22)
        self.assertEqual(sg.ip_permissions[0]['ToPort'], 22)


if __name__ == '__main__':
    unittest.main()
