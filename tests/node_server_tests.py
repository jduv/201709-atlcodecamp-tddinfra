import boto3
import unittest
import json
import botocore

bucketName = '7factor.io'
statefile = open('../terraform.tfstate.backup')
tfstate = json.load(statefile)

class NodeWebServerTests(unittest.TestCase):
    def setUp(self):
        self.ec2 = boto3.resource('ec2')

    def test_serverHasTheRightAMI(self):
        instanceId = tfstate['modules'][0]['resources']['aws_instance.node_instance']['primary']['id']
        instance = self.ec2.Instance(instanceId)
        self.assertEquals(instance.image_id, 'ami-29550952')

if __name__ == '__main__':
    unittest.main()