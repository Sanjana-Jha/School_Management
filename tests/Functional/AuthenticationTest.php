<?php

namespace Tests\Functional;

use Tests\TestCase;

class AuthenticationTest extends TestCase
{
    /**
     * Test that the login page can be rendered.
     *
     * @return void
     */
    public function testLoginPageRender()
    {
        $response = $this->get('/login');

        $response->assertStatus(200);
        $response->assertSee('Login');
        $response->assertSee('password');
    }

    /**
     * Test that logout request redirects properly.
     *
     * @return void
     */
    public function testLogoutRedirects()
    {
        $response = $this->post('/logout');

        $response->assertStatus(302);
    }

    /**
     * Test that the privacy policy page is accessible.
     *
     * @return void
     */
    public function testPrivacyPolicyPage()
    {
        $response = $this->get('/privacy-policy');

        $response->assertStatus(200);
    }

    /**
     * Test that the terms of use page is accessible.
     *
     * @return void
     */
    public function testTermsOfUsePage()
    {
        $response = $this->get('/terms-of-use');

        $response->assertStatus(200);
    }
}
