#!groovy
/*
# Copyright 2017 Juniper Networks, Inc. All rights reserved.
# Licensed under the Juniper Networks Script Software License (the "License").
# You may not use this script file except in compliance with the License, which is located at
# http://www.juniper.net/support/legal/scriptlicense/
# Unless required by applicable law or otherwise agreed to in writing by the parties,
# software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
# either express or implied.
*/
@Library('PS-Shared-libs') _

node('docker') {
    
    stage('Checkout'){
        checkout scm
    }
    stage('Build image'){
        dockerImage action: 'build'
    }

    stage('Push image'){
        dockerImage action: 'push'
    }

    stage('Push to Docker Hub'){
        // Not actually rebuilding, due to cache. Using for the purpose of retagging.
        dockerImage action: 'build', tag: 'juniperps/pytest'

        // Using ssteiner's DockerHub credentials (ntwrkguru)
        dockerImage action: 'push', url: '', credentials: '1a7b4d9f-8b15-4d93-beb9-8d34f010f543'
    }
}