# antautosurf_render.py
# PLAYWRIGHT HEADLESS SU RENDER (SENZA PROXY)

import asyncio
from playwright.async_api import async_playwright
import time
import re
import os

EMAIL = "rixxant@libero.it"
PASSWORD = "GH56$!dama"
BASE_URL = "https://antautosurf.com"

def log(msg):
    print(f"[{time.strftime('%H:%M:%S')}] {msg}")

async def main():
    log("🚀 Avvio AntAutosurf su Render (headless)...")
    
    async with async_playwright() as p:
        # Browser headless (essenziale per Render)
        browser = await p.firefox.launch(
            headless=True,
            args=['--no-sandbox']
        )
        context = await browser.new_context(
            user_agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:141.0) Gecko/20100101 Firefox/141.0"
        )
        page = await context.new_page()
        
        try:
            # 1. Login
            log("📄 Login...")
            await page.goto(BASE_URL, timeout=60000)
            await page.wait_for_load_state("networkidle")
            
            # Email
            await page.fill('input[name="bitcoinwallet"]', EMAIL)
            await page.click('input[type="submit"]')
            log("   ✅ Email inviata")
            await page.wait_for_timeout(3000)
            
            # Password (se c'è)
            try:
                await page.wait_for_selector('input[name="password"]', timeout=5000)
                await page.fill('input[name="password"]', PASSWORD)
                await page.click('input[type="submit"]')
                log("   ✅ Password inviata")
                await page.wait_for_timeout(3000)
            except:
                log("   ℹ️ Password non richiesta")
            
            # Captcha (se c'è)
            try:
                await page.wait_for_selector('img[src*="captcha"]', timeout=5000)
                log("   🔍 Captcha trovato! Risolvi manualmente.")
                # Su Render non possiamo risolvere manualmente, quindi usciamo
                log("   ❌ Captcha richiesto, impossibile su Render")
                return
            except:
                pass
            
            # Aspetta Start Surf
            await page.wait_for_selector('#button1', timeout=30000)
            log("   ✅ Pagina di surf caricata!")
            
            # Clicca Start Surf
            await page.click('#button1')
            log("   ✅ Start Surf cliccato!")
            await page.wait_for_timeout(5000)
            
            # 2. Ciclo di surf
            cycle = 0
            while True:
                cycle += 1
                log(f"\n📊 Ciclo {cycle}")
                
                # Aspetta 15 secondi
                await page.wait_for_timeout(15000)
                
                # Controlla il saldo
                try:
                    balance = await page.text_content('#btoday')
                    log(f"💰 Saldo: {balance}")
                except:
                    log("   ⚠️ Saldo non trovato")
                
                # Verifica se il surf è ancora attivo
                if await page.locator('#button2').count() > 0:
                    log("   ✅ Surf attivo")
                else:
                    log("   ⚠️ Surf non attivo, ricarico...")
                    break
                
        except Exception as e:
            log(f"❌ Errore: {e}")
            import traceback
            traceback.print_exc()
        finally:
            await browser.close()

if __name__ == "__main__":
    asyncio.run(main())
