<?php

namespace Tests\Unit;

use PHPUnit\Framework\TestCase;
use App\Helpers\Qs;

class QsHelperTest extends TestCase
{
    /**
     * Test team role groups.
     *
     * @return void
     */
    public function testTeamRoleDefinitions()
    {
        $teamSA = Qs::getTeamSA();
        $this->assertContains('admin', $teamSA);
        $this->assertContains('super_admin', $teamSA);

        $teamAccount = Qs::getTeamAccount();
        $this->assertContains('accountant', $teamAccount);

        $teamSAT = Qs::getTeamSAT();
        $this->assertContains('teacher', $teamSAT);
    }

    /**
     * Test formatBytes helper.
     *
     * @return void
     */
    public function testFormatBytes()
    {
        $this->assertEquals('1 KB', Qs::formatBytes(1024, 0));
        $this->assertEquals('1 MB', Qs::formatBytes(1048576, 0));
    }

    /**
     * Test hash generation.
     *
     * @return void
     */
    public function testHashGeneration()
    {
        $hash1 = Qs::hash(1);
        $hash2 = Qs::hash(2);

        $this->assertNotEmpty($hash1);
        $this->assertNotEmpty($hash2);
        $this->assertNotEquals($hash1, $hash2);
    }

    /**
     * Test user record fields array.
     *
     * @return void
     */
    public function testGetUserRecordFields()
    {
        $fields = Qs::getUserRecord();

        $this->assertContains('name', $fields);
        $this->assertContains('email', $fields);
        $this->assertContains('phone', $fields);
        $this->assertContains('address', $fields);

        $filtered = Qs::getUserRecord(['phone', 'phone2']);
        $this->assertNotContains('phone', $filtered);
        $this->assertNotContains('phone2', $filtered);
    }
}

